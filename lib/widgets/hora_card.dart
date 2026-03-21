import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/hora.dart';

class HoraCard extends StatelessWidget {
  final HoraResult hora;

  const HoraCard({super.key, required this.hora});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timeFormat = DateFormat('h:mm a');

    final cardColor = isDark
        ? const Color(0xFF2A1A00)
        : const Color(0xFFFFF8E7);
    final accentColor = const Color(0xFFD4860A);
    final titleColor = isDark ? const Color(0xFFFFD580) : const Color(0xFF8B5E00);

    final badgeColor = hora.isNight ? const Color(0xFF3F51B5) : const Color(0xFFE67E00);
    final badgeLabel = hora.isNight ? 'இரவு' : 'பகல்';

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
                Icon(Icons.wb_sunny_outlined, color: accentColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  'கிரக ஓரை',
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
              hora.planet.tamilName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A0A00),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: accentColor.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text(
                  '${timeFormat.format(hora.startTime)} – ${timeFormat.format(hora.endTime)}',
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
