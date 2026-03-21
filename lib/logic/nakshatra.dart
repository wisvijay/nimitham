import 'dart:math';
import 'vsop87_constants.dart';

// 27 Nakshatras × 13°20' each = 360°
// 4 Padas per Nakshatra × 3°20' each

const List<String> nakshatraNames = [
  'அசுவினி',      // 0
  'பரணி',         // 1
  'கார்த்திகை',   // 2
  'ரோகிணி',       // 3
  'மிருகசீரிஷம்', // 4
  'திருவாதிரை',   // 5
  'புனர்பூசம்',   // 6
  'பூசம்',        // 7
  'ஆயில்யம்',    // 8
  'மகம்',         // 9
  'பூரம்',        // 10
  'உத்திரம்',     // 11
  'அஸ்தம்',       // 12
  'சித்திரை',     // 13
  'சுவாதி',       // 14
  'விசாகம்',      // 15
  'அனுஷம்',       // 16
  'கேட்டை',       // 17
  'மூலம்',        // 18
  'பூராடம்',      // 19
  'உத்திராடம்',   // 20
  'திருவோணம்',    // 21
  'அவிட்டம்',     // 22
  'சதயம்',        // 23
  'பூரட்டாதி',    // 24
  'உத்திரட்டாதி', // 25
  'ரேவதி',        // 26
];

class NakshatraResult {
  final String name;       // Tamil name
  final int index;         // 0–26
  final int pada;          // 1–4
  final double moonLon;    // Nirayana Moon longitude (degrees)

  const NakshatraResult({
    required this.name,
    required this.index,
    required this.pada,
    required this.moonLon,
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

/// Moon Nirayana longitude (degrees) using ELP2000 truncated
double _moonNirayana(DateTime now) {
  final utc = now.toUtc();
  final jd = _julianDay(utc);
  final t = (jd - 2451545.0) / 36525.0; // Julian centuries

  final lp = _mod360(kMoonLpBase + kMoonLpRate * t);
  final dm = _mod360(kMoonDBase  + kMoonDRate  * t);
  final ms = _mod360(kMoonMBase  + kMoonMRate  * t);
  final mp = _mod360(kMoonMpBase + kMoonMpRate * t);
  final f  = _mod360(kMoonFBase  + kMoonFRate  * t);

  double sigma = 0;
  for (final term in kMoonLTerms) {
    final arg = _toRad(term[1]*dm + term[2]*ms + term[3]*mp + term[4]*f);
    sigma += term[0] * sin(arg);
  }

  final tropical = _mod360(lp + sigma);
  final aya = kAyanamsaBase + kAyanamsaRate * (t * 100);
  return _mod360(tropical - aya);
}

NakshatraResult getNakshatra(DateTime now) {
  final moonLon = _moonNirayana(now);

  // Each nakshatra = 360/27 = 13.3333°
  const span = 360.0 / 27.0;
  final idx = (moonLon / span).floor() % 27;
  final posInNak = moonLon % span;
  final pada = ((posInNak / (span / 4)).floor() + 1).clamp(1, 4);

  return NakshatraResult(
    name: nakshatraNames[idx],
    index: idx,
    pada: pada,
    moonLon: moonLon,
  );
}
