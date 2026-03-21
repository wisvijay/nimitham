import 'package:flutter/material.dart';
import '../logic/nakshatra.dart';

class NakshatraCard extends StatelessWidget {
  final NakshatraResult nakshatra;

  const NakshatraCard({super.key, required this.nakshatra});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF001A10) : const Color(0xFFE8F5E9);
    final accentColor = const Color(0xFF2E7D32);
    final titleColor = isDark ? const Color(0xFF81C784) : const Color(0xFF1B5E20);

    final badgeColor = const Color(0xFF388E3C);

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
            // Header row
            Row(
              children: [
                Icon(Icons.star_outline, color: accentColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  'நட்சத்திரம்',
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                // Pada badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'பாதம் ${nakshatra.pada}',
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

            // Nakshatra name
            Text(
              nakshatra.name,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1B5E20),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),

            // Moon longitude info
            Row(
              children: [
                Icon(Icons.nightlight_round, size: 16,
                    color: accentColor.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text(
                  'சந்திரன்: ${nakshatra.moonLon.toStringAsFixed(2)}°',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white60 : Colors.black54,
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
