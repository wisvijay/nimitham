import 'dart:math';

class GrahaPosition {
  final String name;
  final String tamilName;
  final String symbol;
  final String rasiName;
  final String rasiTamil;
  final int rasiNumber; // 1-based

  const GrahaPosition({
    required this.name,
    required this.tamilName,
    required this.symbol,
    required this.rasiName,
    required this.rasiTamil,
    required this.rasiNumber,
  });
}

const List<String> _rasiNames = [
  'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
  'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
];

const List<String> _rasiTamil = [
  'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்', 'சிம்மம்', 'கன்னி',
  'துலாம்', 'விருச்சிகம்', 'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
];

double _mod360(double x) => x - 360.0 * (x / 360.0).floor();

double _julianDay(DateTime utc) {
  int y = utc.year;
  int m = utc.month;
  final int d = utc.day;
  final double h = utc.hour + utc.minute / 60.0 + utc.second / 3600.0;
  if (m <= 2) {
    y--;
    m += 12;
  }
  final int a = (y / 100).floor();
  final int b = 2 - a + (a / 4).floor();
  return (365.25 * (y + 4716)).floor() +
      (30.6001 * (m + 1)).floor() +
      d +
      h / 24.0 +
      b -
      1524.5;
}

double _toRad(double deg) => deg * pi / 180.0;

GrahaPosition _makePosition(
    String name, String tamilName, String symbol, double longitude) {
  final int rasiIdx = (longitude / 30).floor() % 12;
  return GrahaPosition(
    name: name,
    tamilName: tamilName,
    symbol: symbol,
    rasiName: _rasiNames[rasiIdx],
    rasiTamil: _rasiTamil[rasiIdx],
    rasiNumber: rasiIdx + 1,
  );
}

List<GrahaPosition> getNavagrahaPositions(DateTime now) {
  final utc = now.toUtc();
  final jd = _julianDay(utc);
  final t = (jd - 2451545.0) / 36525.0;
  final d = jd - 2451545.0;

  // Sun
  final l0 = _mod360(280.46646 + 36000.76983 * t);
  final mSun = _mod360(357.52911 + 35999.05029 * t);
  final mSunRad = _toRad(mSun);
  final c = (1.914602 - 0.004817 * t - 0.000014 * t * t) * sin(mSunRad) +
      (0.019993 - 0.000101 * t) * sin(2 * mSunRad) +
      0.000289 * sin(3 * mSunRad);
  final sunLon = _mod360(l0 + c);

  // Moon (simplified mean longitude)
  final moonLon = _mod360(218.3165 + 13.176396 * d);

  // Mars
  final marsLon = _mod360(355.433 + 0.524033 * d);

  // Mercury
  final mercuryLon = _mod360(252.251 + 4.092335 * d);

  // Jupiter
  final jupiterLon = _mod360(34.351 + 0.083056 * d);

  // Venus
  final venusLon = _mod360(181.979 + 1.602136 * d);

  // Saturn
  final saturnLon = _mod360(50.077 + 0.033459 * d);

  // Rahu (Mean North Node — retrograde)
  final rahuLon = _mod360(125.0445 - 0.052954 * d);

  // Ketu = Rahu + 180
  final ketuLon = _mod360(rahuLon + 180.0);

  return [
    _makePosition('Sun', 'சூரியன்', '☉', sunLon),
    _makePosition('Moon', 'சந்திரன்', '☽', moonLon),
    _makePosition('Mars', 'செவ்வாய்', '♂', marsLon),
    _makePosition('Mercury', 'புதன்', '☿', mercuryLon),
    _makePosition('Jupiter', 'குரு', '♃', jupiterLon),
    _makePosition('Venus', 'சுக்கிரன்', '♀', venusLon),
    _makePosition('Saturn', 'சனி', '♄', saturnLon),
    _makePosition('Rahu', 'ராகு', '☊', rahuLon),
    _makePosition('Ketu', 'கேது', '☋', ketuLon),
  ];
}
