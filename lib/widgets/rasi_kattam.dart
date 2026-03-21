import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/navagraha.dart';

// Fixed grid positions for each rasi (0-based index, 0=Mesha)
const List<(int, int)> _rasiGridPos = [
  (0, 1), // 0 மேஷம்
  (0, 2), // 1 ரிஷபம்
  (0, 3), // 2 மிதுனம்
  (1, 3), // 3 கடகம்
  (2, 3), // 4 சிம்மம்
  (3, 3), // 5 கன்னி
  (3, 2), // 6 துலாம்
  (3, 1), // 7 விருச்சிகம்
  (3, 0), // 8 தனுசு
  (2, 0), // 9 மகரம்
  (1, 0), // 10 கும்பம்
  (0, 0), // 11 மீனம்
];

const List<String> _rasiTamil = [
  'மேஷம்', 'ரிஷபம்', 'மிதுனம்', 'கடகம்', 'சிம்மம்', 'கன்னி',
  'துலாம்', 'விருச்சிகம்', 'தனுசு', 'மகரம்', 'கும்பம்', 'மீனம்',
];

class RasiKattam extends StatelessWidget {
  final List<GrahaPosition> positions;
  final DateTime now;
  final DateTime generatedAt;
  final VoidCallback onRefresh;

  const RasiKattam({
    super.key,
    required this.positions,
    required this.now,
    required this.generatedAt,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = const Color(0xFFD4860A);
    final titleColor = isDark ? const Color(0xFFFFD580) : const Color(0xFF8B5E00);

    // Group planets by rasi (0-based index)
    final Map<int, List<GrahaPosition>> byRasi = {};
    for (final p in positions) {
      final idx = p.rasiNumber - 1; // rasiNumber is 1-based
      byRasi.putIfAbsent(idx, () => []).add(p);
    }

    final ist = generatedAt.toUtc().add(const Duration(hours: 5, minutes: 30));
    final generatedTimeStr = DateFormat('h:mm a').format(ist);
    final mutedColor = isDark ? Colors.white38 : Colors.black38;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.grid_view_rounded, color: accentColor, size: 22),
            const SizedBox(width: 8),
            Text(
              'நவகிரக ராசி கட்டம்',
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'உருவாக்கிய நேரம்: $generatedTimeStr',
          style: TextStyle(fontSize: 13, color: mutedColor),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final cellSize = totalWidth / 4;

            // Build 4x4 grid of cells, center 4 cells left transparent
            final grid = List.generate(4, (row) {
              return List.generate(4, (col) {
                final isCenter = (row == 1 || row == 2) && (col == 1 || col == 2);
                if (isCenter) return null; // placeholder for center overlay

                // Find which rasi this cell is
                int? rasiIdx;
                for (int i = 0; i < _rasiGridPos.length; i++) {
                  if (_rasiGridPos[i] == (row, col)) {
                    rasiIdx = i;
                    break;
                  }
                }

                final planets = rasiIdx != null ? (byRasi[rasiIdx] ?? []) : <GrahaPosition>[];
                final rasiName = rasiIdx != null ? _rasiTamil[rasiIdx] : '';

                return _RasiCell(
                  rasiName: rasiName,
                  planets: planets,
                  isDark: isDark,
                  cellSize: cellSize,
                );
              });
            });

            return Stack(
              children: [
                // 4x4 grid
                Column(
                  children: List.generate(4, (row) {
                    return Row(
                      children: List.generate(4, (col) {
                        final cell = grid[row][col];
                        if (cell == null) {
                          // Transparent placeholder for center cells
                          return SizedBox(width: cellSize, height: cellSize);
                        }
                        return cell;
                      }),
                    );
                  }),
                ),
                // Center 2x2 overlay
                Positioned(
                  left: cellSize,
                  top: cellSize,
                  width: cellSize * 2,
                  height: cellSize * 2,
                  child: _CenterBox(now: now, isDark: isDark),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        // Refresh button — elevated with shadow
        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(14),
          shadowColor: accentColor.withValues(alpha: 0.4),
          color: accentColor,
          child: InkWell(
            onTap: onRefresh,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'புதுப்பி',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RasiCell extends StatelessWidget {
  final String rasiName;
  final List<GrahaPosition> planets;
  final bool isDark;
  final double cellSize;

  const _RasiCell({
    required this.rasiName,
    required this.planets,
    required this.isDark,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF2A1A00) : const Color(0xFFFFF8E7);
    final borderColor = const Color(0xFFD4860A).withValues(alpha: 0.5);
    final rasiLabelColor = isDark ? Colors.white38 : Colors.black38;
    final nameColor = isDark ? Colors.white70 : const Color(0xFF1A0A00);

    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rasi name at top-left
              Text(
                rasiName,
                style: TextStyle(
                  fontSize: 13,
                  color: rasiLabelColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              // Planets
              Expanded(
                child: planets.isEmpty
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < planets.length; i++) ...[
                              if (i > 0) const SizedBox(height: 2),
                              Text(
                                planets[i].tamilName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: nameColor,
                                  height: 1.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterBox extends StatelessWidget {
  final DateTime now;
  final bool isDark;

  const _CenterBox({required this.now, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF2A1A00) : const Color(0xFFFFF8E7);
    final borderColor = const Color(0xFFD4860A).withValues(alpha: 0.5);
    final titleColor = isDark ? const Color(0xFFFFD580) : const Color(0xFF8B5E00);
    final dateColor = isDark ? Colors.white54 : Colors.black45;

    final ist = now.toUtc().add(const Duration(hours: 5, minutes: 30));
    final dateStr = DateFormat('d MMM y').format(ist);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ராசி கட்டம்',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 12,
                color: dateColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
