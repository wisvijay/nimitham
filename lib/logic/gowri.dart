// Gowri Panchangam — full 24-hour coverage
// பகல்: 8 slots × 1.5hr = 6:00 AM → 6:00 PM
// இரவு: 8 slots × 1.5hr = 6:00 PM → 6:00 AM (next day)
//
// weekday: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun (Dart convention)
// Slots: 0=6-7:30, 1=7:30-9, 2=9-10:30, 3=10:30-12,
//        4=12-1:30, 5=1:30-3, 6=3-4:30, 7=4:30-6

const String _uthi   = 'உத்தி';
const String _amirta = 'அமிர்த';
const String _rogam  = 'ரோகம்';
const String _labam  = 'லாபம்';
const String _danam  = 'தனம்';
const String _sugam  = 'சுகம்';
const String _soram  = 'சோரம்';
const String _visam  = 'விஷம்';

// [pagal(8), iravu(8)] — verified table
const Map<int, List<List<String>>> _gowriTable = {
  7: [ // ஞாயிறு Sunday
    [_uthi,  _amirta, _rogam, _labam, _danam, _sugam,  _soram, _visam], // பகல்
    [_danam, _sugam,  _soram, _visam, _uthi,  _amirta, _rogam, _labam], // இரவு
  ],
  1: [ // திங்கள் Monday
    [_amirta, _visam, _rogam, _labam, _danam, _sugam,  _soram, _uthi ], // பகல்
    [_sugam,  _soram, _uthi,  _amirta, _visam, _rogam, _labam, _danam], // இரவு
  ],
  2: [ // செவ்வாய் Tuesday
    [_rogam, _labam, _danam, _sugam, _soram, _uthi,  _visam, _amirta], // பகல்
    [_soram, _uthi,  _visam, _amirta, _rogam, _labam, _danam, _sugam], // இரவு
  ],
  3: [ // புதன் Wednesday
    [_labam, _danam, _sugam, _soram, _visam, _uthi,  _amirta, _rogam], // பகல்
    [_uthi,  _amirta, _rogam, _labam, _danam, _sugam, _soram, _visam], // இரவு
  ],
  4: [ // வியாழன் Thursday
    [_danam, _sugam, _soram, _uthi,  _amirta, _visam, _rogam, _labam], // பகல்
    [_amirta, _visam, _rogam, _labam, _danam, _sugam, _soram, _uthi ], // இரவு
  ],
  5: [ // வெள்ளி Friday
    [_sugam, _soram, _uthi,  _visam, _amirta, _rogam, _labam, _danam], // பகல்
    [_rogam, _labam, _danam, _sugam, _soram,  _uthi,  _visam, _amirta], // இரவு
  ],
  6: [ // சனி Saturday
    [_soram, _uthi,  _visam, _amirta, _rogam, _labam, _danam, _sugam], // பகல்
    [_labam, _danam, _sugam, _soram,  _uthi,  _visam, _amirta, _soram], // இரவு
  ],
};

class GowriResult {
  final String label;       // Tamil slot name
  final DateTime startTime; // IST slot start
  final DateTime endTime;   // IST slot end
  final int slotIndex;      // 0–7
  final bool isNight;       // true = இரவு, false = பகல்

  const GowriResult({
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.slotIndex,
    required this.isNight,
  });
}

/// Always returns a result — covers the full 24 hours.
GowriResult getCurrentGowri(DateTime now) {
  final ist = now.toUtc().add(const Duration(hours: 5, minutes: 30));
  final h = ist.hour;
  final m = ist.minute;

  // ── பகல் window: 6:00 AM ≤ time < 6:00 PM ─────────────────────────
  if (h >= 6 && h < 18) {
    final sessionStart = DateTime(ist.year, ist.month, ist.day, 6, 0, 0);
    final elapsed = (h - 6) * 60 + m;
    final slotIndex = (elapsed ~/ 90).clamp(0, 7);
    final slotStart = sessionStart.add(Duration(minutes: slotIndex * 90));
    return GowriResult(
      label: _gowriTable[ist.weekday]![0][slotIndex],
      startTime: slotStart,
      endTime: slotStart.add(const Duration(minutes: 90)),
      slotIndex: slotIndex,
      isNight: false,
    );
  }

  // ── இரவு window: 6:00 PM → 5:59:59 AM ─────────────────────────────
  final int weekday;
  final DateTime sessionStart;
  final int elapsedMinutes;

  if (h < 6) {
    // 0:00–5:59 AM — night started at 6 PM yesterday
    final yesterday = ist.subtract(const Duration(days: 1));
    weekday = yesterday.weekday;
    sessionStart = DateTime(yesterday.year, yesterday.month, yesterday.day, 18, 0, 0);
    elapsedMinutes = (h + 6) * 60 + m;
  } else {
    // h >= 18 — night starts at 6 PM today
    weekday = ist.weekday;
    sessionStart = DateTime(ist.year, ist.month, ist.day, 18, 0, 0);
    elapsedMinutes = (h - 18) * 60 + m;
  }

  final slotIndex = (elapsedMinutes ~/ 90).clamp(0, 7);
  final slotStart = sessionStart.add(Duration(minutes: slotIndex * 90));

  return GowriResult(
    label: _gowriTable[weekday]![1][slotIndex],
    startTime: slotStart,
    endTime: slotStart.add(const Duration(minutes: 90)),
    slotIndex: slotIndex,
    isNight: true,
  );
}
