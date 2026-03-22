import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/panchang.dart';

class PanchangCard extends StatelessWidget {
  final ThidhiResult thidhi;
  final KaranamResult karanam;

  const PanchangCard({super.key, required this.thidhi, required this.karanam});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF0A001A) : const Color(0xFFF3EEFF);
    final accentColor = const Color(0xFF6A1B9A);
    final titleColor = isDark ? const Color(0xFFCE93D8) : const Color(0xFF4A148C);
    final timeFormat = DateFormat('h:mm a');

    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: accentColor.withValues(alpha: 0.35), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.calendar_month, color: accentColor, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'திதி & கரணம்',
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Thidhi row
            _PanchangRow(
              label: 'திதி',
              value: thidhi.name,
              subValue: thidhi.paksha,
              endTime: thidhi.endTime != null ? timeFormat.format(thidhi.endTime!) : null,
              isDark: isDark,
              accentColor: accentColor,
            ),
            const SizedBox(height: 14),

            Divider(color: accentColor.withValues(alpha: 0.15), height: 1),
            const SizedBox(height: 14),

            // Karanam row
            _PanchangRow(
              label: 'கரணம்',
              value: karanam.name,
              subValue: null,
              endTime: karanam.endTime != null ? timeFormat.format(karanam.endTime!) : null,
              isDark: isDark,
              accentColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _PanchangRow extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final String? endTime;
  final bool isDark;
  final Color accentColor;

  const _PanchangRow({
    required this.label,
    required this.value,
    required this.subValue,
    required this.endTime,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white38 : Colors.black38,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        // Main value
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A0030),
            height: 1.1,
          ),
        ),
        if (subValue != null) ...[
          const SizedBox(height: 2),
          Text(
            subValue!,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
        if (endTime != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.access_time, size: 14,
                  color: accentColor.withValues(alpha: 0.7)),
              const SizedBox(width: 4),
              Text(
                'முடிவு: $endTime',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
