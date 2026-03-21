import 'dart:convert';
import 'package:flutter/services.dart';


class GowriResult {
  final String label;
  final DateTime startTime;
  final DateTime endTime;
  final int slotIndex;
  final bool isNight;

  const GowriResult({
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.slotIndex,
    required this.isNight,
  });
}

Map<String, dynamic>? _cachedData;

Future<Map<String, dynamic>> _loadGowriData() async {
  _cachedData ??= jsonDecode(
    await rootBundle.loadString('assets/gowri/gowri.json'),
  ) as Map<String, dynamic>;
  return _cachedData!;
}

Future<GowriResult> getCurrentGowri(DateTime now) async {
  final data = await _loadGowriData();
  final ist = now.toUtc().add(const Duration(hours: 5, minutes: 30));
  final h = ist.hour;
  final m = ist.minute;

  final days = data['days'] as Map<String, dynamic>;
  final weekday = ist.weekday; // 1=Mon..7=Sun

  // ── பகல் window: 6:00 AM ≤ time < 6:00 PM ─────────────────────────
  if (h >= 6 && h < 18) {
    final elapsed = (h - 6) * 60 + m;
    final slotIndex = (elapsed ~/ 90).clamp(0, 7);
    final sessionStart = DateTime(ist.year, ist.month, ist.day, 6, 0);
    final slotStart = sessionStart.add(Duration(minutes: slotIndex * 90));
    final slots = (days['$weekday']['pagal'] as List).cast<String>();
    return GowriResult(
      label: slots[slotIndex],
      startTime: slotStart,
      endTime: slotStart.add(const Duration(minutes: 90)),
      slotIndex: slotIndex,
      isNight: false,
    );
  }

  // ── இரவு window: 6:00 PM → 5:59:59 AM ─────────────────────────────
  final int wd;
  final DateTime sessionStart;
  final int elapsedMinutes;

  if (h < 6) {
    final yesterday = ist.subtract(const Duration(days: 1));
    wd = yesterday.weekday;
    sessionStart = DateTime(yesterday.year, yesterday.month, yesterday.day, 18, 0);
    elapsedMinutes = (h + 6) * 60 + m;
  } else {
    wd = weekday;
    sessionStart = DateTime(ist.year, ist.month, ist.day, 18, 0);
    elapsedMinutes = (h - 18) * 60 + m;
  }

  final slotIndex = (elapsedMinutes ~/ 90).clamp(0, 7);
  final slotStart = sessionStart.add(Duration(minutes: slotIndex * 90));
  final slots = (days['$wd']['iravu'] as List).cast<String>();

  return GowriResult(
    label: slots[slotIndex],
    startTime: slotStart,
    endTime: slotStart.add(const Duration(minutes: 90)),
    slotIndex: slotIndex,
    isNight: true,
  );
}
