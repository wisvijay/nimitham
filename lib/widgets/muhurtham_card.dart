import 'package:flutter/material.dart';
import '../logic/muhurtham.dart';

class MuhurthamCard extends StatelessWidget {
  final MuhurthamTimings timings;

  const MuhurthamCard({super.key, required this.timings});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1A0A0A) : const Color(0xFFFFF3F3);
    final titleColor = isDark ? const Color(0xFFFF8A80) : const Color(0xFFB71C1C);
    final accentColor = const Color(0xFFC62828);

    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: accentColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: accentColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  'தீய நேரங்கள்',
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rahu Kalam
            _TimingRow(
              label: 'ராகு காலம்',
              start: timings.rahuKalamStart,
              end: timings.rahuKalamEnd,
              isActive: timings.isRahuKalam,
              isDark: isDark,
              color: const Color(0xFFC62828),
            ),
            const SizedBox(height: 10),

            // Emagandam
            _TimingRow(
              label: 'எமகண்டம்',
              start: timings.emagandamStart,
              end: timings.emagandamEnd,
              isActive: timings.isEmagandam,
              isDark: isDark,
              color: const Color(0xFFAD1457),
            ),
            const SizedBox(height: 10),

            // Kuligai
            _TimingRow(
              label: 'குளிகை',
              start: timings.kuligaiStart,
              end: timings.kuligaiEnd,
              isActive: timings.isKuligai,
              isDark: isDark,
              color: const Color(0xFF6A1B9A),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimingRow extends StatelessWidget {
  final String label;
  final String start;
  final String end;
  final bool isActive;
  final bool isDark;
  final Color color;

  const _TimingRow({
    required this.label,
    required this.start,
    required this.end,
    required this.isActive,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: isDark ? 0.3 : 0.12)
            : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.7) : color.withValues(alpha: 0.2),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Active indicator dot
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : color.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: 10),
          // Label
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? (isDark ? Colors.white : Colors.black87)
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
            ),
          ),
          // Time range
          Text(
            '$start – $end',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? color : (isDark ? Colors.white54 : Colors.black45),
            ),
          ),
          if (isActive) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'இப்போது',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
