import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/lagnam.dart';

class LagnamCard extends StatelessWidget {
  final LagnamResult lagnam;

  const LagnamCard({super.key, required this.lagnam});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timeFormat = DateFormat('h:mm a');

    final cardColor = isDark ? const Color(0xFF1A0A2E) : const Color(0xFFF3EFFF);
    final accentColor = const Color(0xFF7B3FC4);
    final titleColor = isDark ? const Color(0xFFCDB4FF) : const Color(0xFF4A0E8F);

    final badgeColor = lagnam.isNight ? const Color(0xFF3F51B5) : const Color(0xFFE67E00);
    final badgeLabel = lagnam.isNight ? 'இரவு' : 'பகல்';

    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: accentColor.withValues(alpha: 0.4), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: accentColor, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'லக்னம்',
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              lagnam.lagnaName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A0030),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${lagnam.tamilDate.monthName} ${lagnam.tamilDate.date}',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: accentColor.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Flexible(
                  child: Builder(builder: (context) {
                    final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
                    final endIst = lagnam.endTime;
                    final isNextDay = endIst.day != now.day || endIst.isBefore(now);
                    final prefix = isNextDay ? 'நாளை ' : '';
                    return Text(
                      'முடிவு நேரம்: $prefix${timeFormat.format(lagnam.endTime)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
