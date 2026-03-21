import 'dart:math';
import 'vsop87_constants.dart';

class GrahaPosition {
  final String name;
  final String tamilName;
  final String tamilShort;
  final String symbol;
  final String rasiName;
  final String rasiTamil;
  final int rasiNumber; // 1-based

  const GrahaPosition({
    required this.name,
    required this.tamilName,
    required this.tamilShort,
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

const Map<String, String> _shortNames = {
  'Sun':     'சூரி',
  'Moon':    'சந்',
  'Mars':    'செவ்',
  'Mercury': 'புத',
  'Jupiter': 'குரு',
  'Venus':   'சுக்',
  'Saturn':  'சனி',
  'Rahu':    'ராகு',
  'Ketu':    'கேது',
};

double _mod360(double x) => ((x % 360) + 360) % 360;
double _toRad(double deg) => deg * pi / 180.0;

/// VSOP87 series sum: Σ A·cos(B + C·τ) where τ is in Julian millennia
double _vsop(List<List<double>> terms, double tau) =>
    terms.fold(0.0, (s, t) => s + t[0] * cos(t[1] + t[2] * tau));

/// Heliocentric longitude (radians) from L0 + L1·τ VSOP87 series
double _helioLon(List<List<double>> l0, List<List<double>> l1, double tau) {
  final l = (_vsop(l0, tau) + _vsop(l1, tau) * tau) * 1e-8;
  return ((l % (2 * pi)) + 2 * pi) % (2 * pi);
}

/// Heliocentric distance (AU) from R0 series
double _helioR(List<List<double>> r0, double tau) => _vsop(r0, tau) * 1e-8;

/// Geocentric ecliptic longitude (degrees) from heliocentric coords
double _geoLon(double planetRad, double planetR, double earthRad, double earthR) {
  final dx = planetR * cos(planetRad) - earthR * cos(earthRad);
  final dy = planetR * sin(planetRad) - earthR * sin(earthRad);
  return _mod360(atan2(dy, dx) * 180 / pi);
}

/// Julian Day Number from UTC DateTime
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

/// Lahiri Ayanamsa (degrees) for given Julian centuries T
double _ayanamsa(double tCenturies) =>
    kAyanamsaBase + kAyanamsaRate * (tCenturies * 100);

/// Sun apparent longitude (tropical, degrees)
double _sunLon(double tCenturies) {
  final l0 = _mod360(kSunL0Base + kSunL0Rate * tCenturies);
  final m  = _mod360(kSunMBase  + kSunMRate  * tCenturies
      + kSunMRate2 * tCenturies * tCenturies);
  final mr = _toRad(m);
  final c = (kSunCCoeffs[0] + kSunCCoeffs[1] * tCenturies
      + kSunCCoeffs[2] * tCenturies * tCenturies) * sin(mr)
      + (kSunC2Coeffs[0] + kSunC2Coeffs[1] * tCenturies) * sin(2 * mr)
      + kSunC3 * sin(3 * mr);
  return _mod360(l0 + c);
}

/// Moon longitude (tropical, degrees) using ELP2000 truncated (Meeus Ch.47)
/// Note: Moon uses Julian centuries T, not millennia τ
double _moonLon(double tCenturies) {
  final lp = _mod360(kMoonLpBase + kMoonLpRate * tCenturies);
  final dm = _mod360(kMoonDBase  + kMoonDRate  * tCenturies);
  final ms = _mod360(kMoonMBase  + kMoonMRate  * tCenturies);
  final mp = _mod360(kMoonMpBase + kMoonMpRate * tCenturies);
  final f  = _mod360(kMoonFBase  + kMoonFRate  * tCenturies);

  double sigma = 0;
  for (final term in kMoonLTerms) {
    final arg = _toRad(term[1]*dm + term[2]*ms + term[3]*mp + term[4]*f);
    sigma += term[0] * sin(arg);
  }
  return _mod360(lp + sigma);
}

/// Rahu (Mean Ascending Node, degrees, tropical)
/// Note: Rahu uses Julian centuries T
double _rahuLon(double tCenturies) =>
    _mod360(kRahuBase + kRahuRate * tCenturies
        + kRahuRate2 * tCenturies * tCenturies
        - kRahuRate3 * tCenturies * tCenturies * tCenturies);

GrahaPosition _makePosition(
    String name, String tamilName, String symbol,
    double tropicalLon, double aya) {
  final nirayana = _mod360(tropicalLon - aya);
  final rasiIdx = (nirayana / 30).floor() % 12;
  return GrahaPosition(
    name: name,
    tamilName: tamilName,
    tamilShort: _shortNames[name] ?? tamilName,
    symbol: symbol,
    rasiName: _rasiNames[rasiIdx],
    rasiTamil: _rasiTamil[rasiIdx],
    rasiNumber: rasiIdx + 1,
  );
}

List<GrahaPosition> getNavagrahaPositions(DateTime now) {
  final utc = now.toUtc();
  final jd = _julianDay(utc);
  final tCenturies = (jd - 2451545.0) / 36525.0;
  final tau = tCenturies / 10.0; // Julian millennia — required for VSOP87
  final aya = _ayanamsa(tCenturies);

  // Earth heliocentric position (needed for geocentric conversion)
  final earthRad = _helioLon(kEarthL0, kEarthL1, tau);
  final earthR   = _helioR(kEarthR0, tau);

  // Outer planets: geocentric via heliocentric - Earth vector
  double outerGeo(List<List<double>> pL0, List<List<double>> pL1,
      List<List<double>> pR0) {
    final pRad = _helioLon(pL0, pL1, tau);
    final pR   = _helioR(pR0, tau);
    return _geoLon(pRad, pR, earthRad, earthR);
  }

  final marsLon    = outerGeo(kMarsL0,    kMarsL1,    kMarsR0);
  final jupiterLon = outerGeo(kJupiterL0, kJupiterL1, kJupiterR0);
  final saturnLon  = outerGeo(kSaturnL0,  kSaturnL1,  kSaturnR0);
  final venusLon   = outerGeo(kVenusL0,   kVenusL1,   kVenusR0);
  final mercuryLon = outerGeo(kMercuryL0, kMercuryL1, kMercuryR0);

  final sunLon  = _sunLon(tCenturies);
  final moonLon = _moonLon(tCenturies);
  final rahuLon = _rahuLon(tCenturies);
  final ketuLon = _mod360(rahuLon + 180.0);

  return [
    _makePosition('Sun',     'சூரியன்',   '☉', sunLon,     aya),
    _makePosition('Moon',    'சந்திரன்',  '☽', moonLon,    aya),
    _makePosition('Mars',    'செவ்வாய்',  '♂', marsLon,    aya),
    _makePosition('Mercury', 'புதன்',     '☿', mercuryLon, aya),
    _makePosition('Jupiter', 'குரு',      '♃', jupiterLon, aya),
    _makePosition('Venus',   'சுக்கிரன்', '♀', venusLon,   aya),
    _makePosition('Saturn',  'சனி',       '♄', saturnLon,  aya),
    _makePosition('Rahu',    'ராகு',      '☊', rahuLon,    aya),
    _makePosition('Ketu',    'கேது',      '☋', ketuLon,    aya),
  ];
}
