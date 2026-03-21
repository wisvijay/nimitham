// Tamil calendar date calculation
// Calibrated: March 20, 2026 = பங்குனி (month 11), Tamil date 6

class TamilDate {
  final int monthIndex; // 0=சித்திரை ... 11=பங்குனி
  final int date;       // 1-32
  final String monthName;

  const TamilDate({required this.monthIndex, required this.date, required this.monthName});
}

const List<String> tamilMonthNames = [
  'சித்திரை', 'வைகாசி', 'ஆனி', 'ஆடி',
  'ஆவணி', 'புரட்டாசி', 'ஐப்பசி', 'கார்த்திகை',
  'மார்கழி', 'தை', 'மாசி', 'பங்குனி',
];

// Tamil month start dates for 2025-2027 (Gregorian month, day)
// Each entry: [year, month, day]
const List<List<int>> _tamilStarts = [
  // 2025
  [2025,  4, 14], // சித்திரை 0
  [2025,  5, 15], // வைகாசி  1
  [2025,  6, 15], // ஆனி     2
  [2025,  7, 17], // ஆடி     3
  [2025,  8, 17], // ஆவணி   4
  [2025,  9, 17], // புரட்டாசி 5
  [2025, 10, 18], // ஐப்பசி  6
  [2025, 11, 16], // கார்த்திகை 7
  [2025, 12, 16], // மார்கழி 8
  // 2026
  [2026,  1, 14], // தை      9
  [2026,  2, 13], // மாசி    10
  [2026,  3, 14], // பங்குனி 11
  [2026,  4, 14], // சித்திரை 0
  [2026,  5, 15], // வைகாசி  1
  [2026,  6, 15], // ஆனி     2
  [2026,  7, 17], // ஆடி     3
  [2026,  8, 17], // ஆவணி   4
  [2026,  9, 17], // புரட்டாசி 5
  [2026, 10, 18], // ஐப்பசி  6
  [2026, 11, 16], // கார்த்திகை 7
  [2026, 12, 16], // மார்கழி 8
  // 2027
  [2027,  1, 14], // தை      9
  [2027,  2, 13], // மாசி    10
  [2027,  3, 14], // பங்குனி 11
  [2027,  4, 14], // சித்திரை 0
];

int _toJulian(int y, int m, int d) =>
    (365.25 * (y + 4716)).floor() +
    (30.6001 * (m + 1)).floor() +
    d - 1524;

TamilDate getTamilDate(DateTime date) {
  final ist = date.toUtc().add(const Duration(hours: 5, minutes: 30));
  final jd = _toJulian(ist.year, ist.month, ist.day);

  // Find which Tamil month this falls in
  for (int i = _tamilStarts.length - 2; i >= 0; i--) {
    final s = _tamilStarts[i];
    final startJd = _toJulian(s[0], s[1], s[2]);
    if (jd >= startJd) {
      final tamilDate = jd - startJd + 1;
      // month index cycles 0-11 based on position in list
      // The list alternates through the 12 months in order
      final monthIdx = _monthIndexForEntry(i);
      return TamilDate(
        monthIndex: monthIdx,
        date: tamilDate.clamp(1, 32),
        monthName: tamilMonthNames[monthIdx],
      );
    }
  }
  // Fallback
  return TamilDate(monthIndex: 11, date: 1, monthName: tamilMonthNames[11]);
}

int _monthIndexForEntry(int entryIndex) {
  // Month indices in order of _tamilStarts list
  const indices = [
    0,1,2,3,4,5,6,7,8, // 2025: சித்திரை..மார்கழி
    9,10,11,            // 2026 early: தை,மாசி,பங்குனி
    0,1,2,3,4,5,6,7,8, // 2026: சித்திரை..மார்கழி
    9,10,11,            // 2027 early: தை,மாசி,பங்குனி
    0,                  // 2027: சித்திரை
  ];
  if (entryIndex < indices.length) return indices[entryIndex];
  return 0;
}
