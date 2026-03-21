// Graha Oorai (Hora) — fixed lookup table from panchangam
// பகல்: 12 slots × 1hr = 6:00 AM → 6:00 PM
// இரவு: 12 slots × 1hr = 6:00 PM → 6:00 AM (next day)
//
// weekday: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun (Dart convention)
// Slots: 0=6-7, 1=7-8, 2=8-9, 3=9-10, 4=10-11, 5=11-12,
//        6=12-1, 7=1-2, 8=2-3, 9=3-4, 10=4-5, 11=5-6

class Planet {
  final String name;
  final String tamilName;
  final String symbol;
  const Planet({required this.name, required this.tamilName, required this.symbol});
}

const Planet _suri  = Planet(name: 'Sun',     tamilName: 'சூரியன்',  symbol: '☉');
const Planet _suk   = Planet(name: 'Venus',   tamilName: 'சுக்கிரன்', symbol: '♀');
const Planet _put   = Planet(name: 'Mercury', tamilName: 'புதன்',    symbol: '☿');
const Planet _san   = Planet(name: 'Moon',    tamilName: 'சந்திரன்',  symbol: '☽');
const Planet _sani  = Planet(name: 'Saturn',  tamilName: 'சனி',      symbol: '♄');
const Planet _guru  = Planet(name: 'Jupiter', tamilName: 'குரு',     symbol: '♃');
const Planet _sev   = Planet(name: 'Mars',    tamilName: 'செவ்வாய்', symbol: '♂');

// [pagal(12), iravu(12)]
const Map<int, List<List<Planet>>> _horaTable = {
  7: [ // ஞாயிறு Sunday
    [_suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani], // பகல்
    [_guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put], // இரவு
  ],
  1: [ // திங்கள் Monday
    [_san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri], // பகல்
    [_suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru], // இரவு
  ],
  2: [ // செவ்வாய் Tuesday
    [_sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san], // பகல்
    [_sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk], // இரவு
  ],
  3: [ // புதன் Wednesday
    [_put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev], // பகல்
    [_suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani], // இரவு
  ],
  4: [ // வியாழன் Thursday
    [_guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put], // பகல்
    [_san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri], // இரவு
  ],
  5: [ // வெள்ளி Friday
    [_suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru], // பகல்
    [_sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san], // இரவு
  ],
  6: [ // சனி Saturday
    [_sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev, _suri, _suk], // பகல்
    [_put, _san, _sani, _guru, _sev, _suri, _suk, _put, _san, _sani, _guru, _sev], // இரவு
  ],
};

class HoraResult {
  final Planet planet;
  final DateTime startTime; // IST
  final DateTime endTime;   // IST
  final int slotIndex;      // 0–11
  final bool isNight;       // true = இரவு

  const HoraResult({
    required this.planet,
    required this.startTime,
    required this.endTime,
    required this.slotIndex,
    required this.isNight,
  });
}

/// Always returns a result — covers the full 24 hours.
HoraResult getCurrentHora(DateTime now) {
  final ist = now.toUtc().add(const Duration(hours: 5, minutes: 30));
  final h = ist.hour;

  // ── பகல் window: 6:00 AM ≤ time < 6:00 PM ─────────────────────────
  if (h >= 6 && h < 18) {
    final slotIndex = h - 6; // 0–11
    final slotStart = DateTime(ist.year, ist.month, ist.day, h, 0, 0);
    return HoraResult(
      planet: _horaTable[ist.weekday]![0][slotIndex],
      startTime: slotStart,
      endTime: slotStart.add(const Duration(hours: 1)),
      slotIndex: slotIndex,
      isNight: false,
    );
  }

  // ── இரவு window: 6:00 PM → 5:59:59 AM ─────────────────────────────
  final int weekday;
  final int slotIndex;
  final DateTime slotStart;

  if (h < 6) {
    // 0:00–5:59 AM — night started at 6 PM yesterday
    final yesterday = ist.subtract(const Duration(days: 1));
    weekday = yesterday.weekday;
    slotIndex = h + 6; // 0:00→6, 1:00→7, ... 5:00→11
    slotStart = DateTime(ist.year, ist.month, ist.day, h, 0, 0);
  } else {
    // h >= 18
    weekday = ist.weekday;
    slotIndex = h - 18; // 18:00→0, 19:00→1, ... 23:00→5
    slotStart = DateTime(ist.year, ist.month, ist.day, h, 0, 0);
  }

  return HoraResult(
    planet: _horaTable[weekday]![1][slotIndex],
    startTime: slotStart,
    endTime: slotStart.add(const Duration(hours: 1)),
    slotIndex: slotIndex,
    isNight: true,
  );
}
