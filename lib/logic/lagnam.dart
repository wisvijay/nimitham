import 'dart:convert';
import 'package:flutter/services.dart';
import 'tamil_calendar.dart';

// Lagna names (index 0-11)
const List<String> lagnaNames = [
  'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்',
  'சிம்மம்', 'கன்னி', 'துலாம்', 'விருச்சிகம்',
  'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
];

const List<String> _monthSlugs = [
  'chittirai','vaikasi','aani','aadi',
  'avani','purattasi','aippasi','karthigai',
  'margazhi','thai','maasi','panguni',
];

class LagnamResult {
  final String lagnaName;
  final DateTime endTime; // IST
  final TamilDate tamilDate;
  final bool isNight;

  const LagnamResult({
    required this.lagnaName,
    required this.endTime,
    required this.tamilDate,
    required this.isNight,
  });
}

/// Parse the full day's 12 lagna end times (12-hour format, no AM/PM).
/// Returns absolute minutes since midnight for each column.
/// The sequence starts after 6:00 AM and is monotonically increasing.
/// When a value drops from the previous, it has crossed 12:00 (noon or midnight).
/// Parse the full day's 12 lagna end times (12-hour clock, no AM/PM).
/// The sequence starts after 6:00 AM and advances monotonically through the day.
/// When the raw clock value drops below the previous, add 720 (crossed a 12-hour boundary).
List<int> _parseTimeSeries(List<String> times) {
  int cumOffset = 0; // accumulated 720-min offsets
  int prev = 360;    // 6:00 AM as anchor
  final result = <int>[];
  for (final t in times) {
    final parts = t.split('-');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final raw = h * 60 + m; // e.g. 7*60+38=458, 1*60+20=80
    int abs = raw + cumOffset;
    // If adding current offset still puts us behind previous, cross a 12h boundary
    if (abs <= prev) {
      cumOffset += 720;
      abs += 720;
    }
    result.add(abs);
    prev = abs;
  }
  return result;
}

/// Convert minutes-since-midnight to IST DateTime on a given IST date.
DateTime _minsToDateTime(int mins, DateTime istDate) {
  final effectiveMins = mins >= 1440 ? mins - 1440 : mins;
  final dayOffset = mins >= 1440 ? 1 : 0;
  final base = DateTime(istDate.year, istDate.month, istDate.day)
      .add(Duration(days: dayOffset));
  return DateTime(base.year, base.month, base.day,
      effectiveMins ~/ 60, effectiveMins % 60);
}

Future<LagnamResult> getCurrentLagnam(DateTime now) async {
  final ist = now.toUtc().add(const Duration(hours: 5, minutes: 30));
  final tDate = getTamilDate(now);

  // Load JSON for this month
  final slug = _monthSlugs[tDate.monthIndex];
  final jsonStr = await rootBundle.loadString('assets/lagna/$slug.json');
  final data = jsonDecode(jsonStr) as Map<String, dynamic>;

  final days = data['days'] as List;
  final colOrder = (data['columnOrder'] as List).cast<int>();

  // Clamp date to available days
  final dayIndex = (tDate.date - 1).clamp(0, days.length - 1);
  final dayTimes = (days[dayIndex] as List).cast<String>();

  // Parse the time series correctly (12h format, monotonically increasing from 6 AM)
  final endTimes = _parseTimeSeries(dayTimes);

  // Current time in minutes since midnight IST
  final nowMins = ist.hour * 60 + ist.minute;

  for (int i = 0; i < 12; i++) {
    if (nowMins <= endTimes[i] % 1440 ||
        (endTimes[i] >= 1440 && nowMins <= endTimes[i] - 1440)) {
      // Simpler: compare directly
    }
  }

  // Direct comparison: find first slot whose end > nowMins
  // endTimes are absolute minutes since midnight, may exceed 1440 for next-day times
  final nowAbsolute = nowMins < 360 ? nowMins + 1440 : nowMins;

  for (int i = 0; i < 12; i++) {
    if (nowAbsolute <= endTimes[i]) {
      return LagnamResult(
        lagnaName: lagnaNames[colOrder[i]],
        endTime: _minsToDateTime(endTimes[i], ist),
        tamilDate: tDate,
        isNight: nowAbsolute >= 1080,
      );
    }
  }

  // Fallback: last lagna
  return LagnamResult(
    lagnaName: lagnaNames[colOrder[11]],
    endTime: _minsToDateTime(endTimes[11], ist),
    tamilDate: tDate,
    isNight: true,
  );
}
