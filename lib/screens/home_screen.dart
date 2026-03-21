import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../logic/hora.dart';
import '../logic/gowri.dart';
import '../logic/navagraha.dart';
import '../logic/lagnam.dart';
import '../logic/nakshatra.dart';
import '../widgets/hora_card.dart';
import '../widgets/gowri_card.dart';
import '../widgets/lagnam_card.dart';
import '../widgets/nakshatra_card.dart';
import '../widgets/rasi_kattam.dart';

const Map<int, String> _weekdayTamil = {
  1: 'திங்கட்கிழமை',  // Monday
  2: 'செவ்வாய்க்கிழமை', // Tuesday
  3: 'புதன்கிழமை',      // Wednesday
  4: 'வியாழக்கிழமை',   // Thursday
  5: 'வெள்ளிக்கிழமை',  // Friday
  6: 'சனிக்கிழமை',     // Saturday
  7: 'ஞாயிற்றுக்கிழமை', // Sunday
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _now;
  late DateTime _generatedAt;
  Timer? _timer;
  LagnamResult? _lagnam;
  GowriResult? _gowri;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _generatedAt = _now;
    _loadAll(_now);
    // Align timer to the next minute boundary for smooth updates
    final secondsToNextMinute = 60 - _now.second;
    Future.delayed(Duration(seconds: secondsToNextMinute), () {
      if (mounted) {
        final now = DateTime.now();
        setState(() => _now = now);
        _loadAll(now);
        _timer = Timer.periodic(const Duration(minutes: 1), (_) {
          if (mounted) {
            final t = DateTime.now();
            setState(() => _now = t);
            _loadAll(t);
          }
        });
      }
    });
  }

  Future<void> _loadAll(DateTime now) async {
    final results = await Future.wait([
      getCurrentLagnam(now),
      getCurrentGowri(now),
    ]);
    if (mounted) {
      setState(() {
        _lagnam = results[0] as LagnamResult;
        _gowri = results[1] as GowriResult;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // IST time
    final ist = _now.toUtc().add(const Duration(hours: 5, minutes: 30));
    final hora = getCurrentHora(_now);
    final nakshatra = getNakshatra(_now);
    final grahaPositions = getNavagrahaPositions(_generatedAt);

    final tamilDay = _weekdayTamil[ist.weekday] ?? '';
    final englishDay = DateFormat('EEEE, d MMMM y').format(ist);
    final timeStr = DateFormat('h:mm a').format(ist);

    final bgColor = isDark
        ? const Color(0xFF0D0700)
        : const Color(0xFFFDF6E3);
    final headerColor = isDark ? const Color(0xFFFFD580) : const Color(0xFF7A4500);

    // Splash screen while loading
    if (_loading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icon/nimitham_logo.svg', width: 180, height: 180),
              const SizedBox(height: 32),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: headerColor,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'தயாராகிறது...',
                style: TextStyle(fontSize: 18, color: headerColor),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App title
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/nimitham_logo.svg',
                          width: 44,
                          height: 44,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'நிமித்தம்',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: headerColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        // Live time
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: headerColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$timeStr IST',
                            style: TextStyle(
                              fontSize: 20,
                              color: headerColor,
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Date display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A0D00)
                            : const Color(0xFFFFEEC7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFD4860A).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tamilDay,
                            style: TextStyle(
                              fontSize: 26,
                              color: isDark ? const Color(0xFFFFD580) : const Color(0xFF7A4500),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            englishDay,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                          if (_lagnam != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${_lagnam!.tamilDate.monthName} ${_lagnam!.tamilDate.date}',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? const Color(0xFFFFD580) : const Color(0xFF7A4500),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  HoraCard(hora: hora),
                  const SizedBox(height: 16),
                  if (_gowri != null) GowriCard(gowri: _gowri!),
                  const SizedBox(height: 16),
                  if (_lagnam != null) ...[
                    LagnamCard(lagnam: _lagnam!),
                    const SizedBox(height: 16),
                  ],
                  NakshatraCard(nakshatra: nakshatra),
                  const SizedBox(height: 16),
                  RasiKattam(
                    positions: grahaPositions,
                    now: _generatedAt,
                    generatedAt: _generatedAt,
                    onRefresh: () => setState(() => _generatedAt = DateTime.now()),
                  ),
                  const SizedBox(height: 32),

                  // Footer note
                  Center(
                    child: Text(
                      'அனைத்து நேரங்களும் IST • ஒவ்வொரு நிமிடமும் புதுப்பிக்கப்படும்',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
