import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/gowri.dart';

class GowriCard extends StatelessWidget {
  final GowriResult gowri;

  const GowriCard({super.key, required this.gowri});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timeFormat = DateFormat('h:mm a');

    final cardColor = isDark
        ? const Color(0xFF001A1A)
        : const Color(0xFFE8F8F5);
    final accentColor = const Color(0xFF0A8B6E);
    final titleColor = isDark ? const Color(0xFF7FFFD4) : const Color(0xFF00614D);

    // Badge: பகல் = gold/saffron, இரவு = dark indigo
    final badgeColor = gowri.isNight ? const Color(0xFF3F51B5) : const Color(0xFFE67E00);
    final badgeLabel = gowri.isNight ? 'இரவு' : 'பகல்';

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
                Icon(Icons.self_improvement, color: accentColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  'கௌரி பஞ்சாங்கம்',
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
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
              gowri.label,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF001A12),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: accentColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  '${timeFormat.format(gowri.startTime)} – ${timeFormat.format(gowri.endTime)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white60 : Colors.black54,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
