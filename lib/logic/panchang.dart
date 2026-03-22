import 'dart:math';
import 'vsop87_constants.dart';

// ── Tithi (திதி) ─────────────────────────────────────────────────────────────
// Moon - Sun longitude difference, every 12° = 1 tithi
// 30 tithis per lunar month (Shukla 1-15, Krishna 1-15)

const List<String> thidhiNames = [
  'பிரதமை',    // 1
  'துவிதியை',  // 2
  'திருதியை',  // 3
  'சதுர்த்தி', // 4
  'பஞ்சமி',    // 5
  'ஷஷ்டி',     // 6
  'சப்தமி',    // 7
  'அஷ்டமி',   // 8
  'நவமி',      // 9
  'தசமி',      // 10
  'ஏகாதசி',   // 11
  'துவாதசி',   // 12
  'திரயோதசி',  // 13
  'சதுர்தசி',  // 14
  'பௌர்ணமி',   // 15 (Shukla) / அமாவாசை (Krishna)
];

const List<String> pakshaNames = ['சுக்ல பக்ஷம்', 'கிருஷ்ண பக்ஷம்'];

// ── Karana (கரணம்) ───────────────────────────────────────────────────────────
// Half a tithi = every 6° difference
// Fixed karanas: Kimstughna (1), Chatushpada (57), Naga (58), Sakuni (60)
// Repeating karanas (7 types, indices 1-7, repeat 8 times each): slots 2-57

const List<String> karanaNames = [
  'கிம்ஸ்துக்ன',  // 0 - fixed, first half of Shukla 1
  'பவ',            // 1 - repeating
  'பாலவ',          // 2
  'கௌலவ',          // 3
  'தைதுல',         // 4
  'கரஜ',           // 5
  'வணிஜ',          // 6
  'விஷ்டி (பத்ரா)',// 7
  'சகுனி',         // 8 - fixed
  'சதுஷ்பாத',      // 9 - fixed
  'நாகவ',          // 10 - fixed
];

class ThidhiResult {
  final String name;
  final String paksha;
  final int number;        // 1-15
  final DateTime? endTime; // IST when tithi ends (approx)

  const ThidhiResult({
    required this.name,
    required this.paksha,
    required this.number,
    this.endTime,
  });
}

class KaranamResult {
  final String name;
  final int number;        // 1-60
  final DateTime? endTime; // IST when karana ends (approx)

  const KaranamResult({
    required this.name,
    required this.number,
    this.endTime,
  });
}

double _mod360(double x) => ((x % 360) + 360) % 360;
double _toRad(double deg) => deg * pi / 180.0;

double _julianDay(DateTime utc) {
  int y = utc.year, m = utc.month, d = utc.day;
  double h = utc.hour + utc.minute / 60.0 + utc.second / 3600.0;
  if (m <= 2) { y--; m += 12; }
  final a = (y / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (y + 4716)).floor() +
      (30.6001 * (m + 1)).floor() +
      d + h / 24.0 + b - 1524.5;
}

/// Sun tropical longitude (degrees)
double _sunLon(double t) {
  final l0 = _mod360(kSunL0Base + kSunL0Rate * t);
  final m  = _mod360(kSunMBase  + kSunMRate  * t);
  final mr = _toRad(m);
  final c = (kSunCCoeffs[0] + kSunCCoeffs[1] * t) * sin(mr)
      + kSunC2Coeffs[0] * sin(2 * mr)
      + kSunC3 * sin(3 * mr);
  return _mod360(l0 + c);
}

/// Moon tropical longitude (degrees) — ELP2000 truncated
double _moonLon(double t) {
  final lp = _mod360(kMoonLpBase + kMoonLpRate * t);
  final dm = _mod360(kMoonDBase  + kMoonDRate  * t);
  final ms = _mod360(kMoonMBase  + kMoonMRate  * t);
  final mp = _mod360(kMoonMpBase + kMoonMpRate * t);
  final f  = _mod360(kMoonFBase  + kMoonFRate  * t);
  double sigma = 0;
  for (final term in kMoonLTerms) {
    sigma += term[0] * sin(_toRad(term[1]*dm + term[2]*ms + term[3]*mp + term[4]*f));
  }
  return _mod360(lp + sigma);
}

/// Moon-Sun difference (0-360°)
double _moonSunDiff(double t) => _mod360(_moonLon(t) - _sunLon(t));

/// Approximate end time of current tithi/karana by finding when
/// the moon-sun angle crosses the next multiple of [step] degrees
DateTime? _findEndTime(DateTime now, double currentAngle, double step) {
  // How many degrees until next boundary
  final nextBoundary = (currentAngle / step).floor() * step + step;
  final degreesLeft = _mod360(nextBoundary - currentAngle);

  // Moon moves ~13°/day relative to Sun, so 1° ≈ 1.8 hours
  final hoursLeft = degreesLeft / (12.0 / 24.0); // ~12° per day
  final endUtc = now.toUtc().add(Duration(minutes: (hoursLeft * 60).round()));
  final endIst = endUtc.add(const Duration(hours: 5, minutes: 30));
  return DateTime(endIst.year, endIst.month, endIst.day, endIst.hour, endIst.minute);
}

ThidhiResult getThidhi(DateTime now) {
  final jd = _julianDay(now.toUtc());
  final t = (jd - 2451545.0) / 36525.0;
  final diff = _moonSunDiff(t);

  // Tithi index 0-29 (0 = Shukla 1st)
  final thidhiIdx = (diff / 12).floor() % 30;
  final isPurnima = thidhiIdx == 14;
  final isAmavasya = thidhiIdx == 29;

  final paksha = thidhiIdx < 15 ? pakshaNames[0] : pakshaNames[1];
  final number = (thidhiIdx % 15) + 1;

  String name;
  if (isPurnima) {
    name = 'பௌர்ணமி';
  } else if (isAmavasya) {
    name = 'அமாவாசை';
  } else {
    name = thidhiNames[(thidhiIdx % 15).clamp(0, 14)];
  }

  final endTime = _findEndTime(now, diff, 12.0);

  return ThidhiResult(
    name: name,
    paksha: paksha,
    number: number,
    endTime: endTime,
  );
}

KaranamResult getKaranam(DateTime now) {
  final jd = _julianDay(now.toUtc());
  final t = (jd - 2451545.0) / 36525.0;
  final diff = _moonSunDiff(t);

  // Karana index 0-59
  final karanaIdx = (diff / 6).floor() % 60;

  String name;
  if (karanaIdx == 0) {
    name = karanaNames[0]; // Kimstughna (fixed)
  } else if (karanaIdx >= 57) {
    // Last 3 fixed karanas
    name = karanaNames[8 + (karanaIdx - 57)];
  } else {
    // Repeating: (karanaIdx - 1) % 7 → index 1-7
    name = karanaNames[((karanaIdx - 1) % 7) + 1];
  }

  final endTime = _findEndTime(now, diff, 6.0);

  return KaranamResult(
    name: name,
    number: karanaIdx + 1,
    endTime: endTime,
  );
}
