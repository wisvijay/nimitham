// Rahu Kalam, Emagandam, Kuligai timings
// Fixed by day of week, based on 6 AM start, 1.5hr slots (slot 0 = 6:00-7:30)
// weekday: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun

class MuhurthamTimings {
  final String rahuKalamStart;
  final String rahuKalamEnd;
  final String emagandamStart;
  final String emagandamEnd;
  final String kuligaiStart;
  final String kuligaiEnd;
  final bool isRahuKalam;
  final bool isEmagandam;
  final bool isKuligai;

  const MuhurthamTimings({
    required this.rahuKalamStart,
    required this.rahuKalamEnd,
    required this.emagandamStart,
    required this.emagandamEnd,
    required this.kuligaiStart,
    required this.kuligaiEnd,
    required this.isRahuKalam,
    required this.isEmagandam,
    required this.isKuligai,
  });
}

// Slot index (0-based from 6 AM):
// 0=6:00-7:30, 1=7:30-9:00, 2=9:00-10:30, 3=10:30-12:00
// 4=12:00-1:30, 5=1:30-3:00, 6=3:00-4:30, 7=4:30-6:00

const _slotTimes = [
  ('6:00',  '7:30'),
  ('7:30',  '9:00'),
  ('9:00',  '10:30'),
  ('10:30', '12:00'),
  ('12:00', '1:30'),
  ('1:30',  '3:00'),
  ('3:00',  '4:30'),
  ('4:30',  '6:00'),
];

// [rahuSlot, emagandamSlot, kuligaiSlot] per weekday
const Map<int, List<int>> _slots = {
  7: [7, 4, 6], // ஞாயிறு Sunday
  1: [1, 3, 5], // திங்கள் Monday
  2: [6, 2, 4], // செவ்வாய் Tuesday
  3: [4, 1, 3], // புதன் Wednesday
  4: [5, 0, 2], // வியாழன் Thursday
  5: [3, 6, 1], // வெள்ளி Friday
  6: [2, 5, 0], // சனி Saturday
};

MuhurthamTimings getMuhurthamTimings(DateTime now) {
  final ist = now.toUtc().add(const Duration(hours: 5, minutes: 30));
  final weekday = ist.weekday;
  final slots = _slots[weekday]!;

  final rahuSlot = slots[0];
  final emagSlot = slots[1];
  final kuliSlot = slots[2];

  // Current time in minutes from 6 AM
  final minFrom6 = (ist.hour - 6) * 60 + ist.minute;
  final currentSlot = (minFrom6 / 90).floor();

  final isRahu  = ist.hour >= 6 && ist.hour < 18 && currentSlot == rahuSlot;
  final isEmag  = ist.hour >= 6 && ist.hour < 18 && currentSlot == emagSlot;
  final isKuli  = ist.hour >= 6 && ist.hour < 18 && currentSlot == kuliSlot;

  return MuhurthamTimings(
    rahuKalamStart:  _slotTimes[rahuSlot].$1,
    rahuKalamEnd:    _slotTimes[rahuSlot].$2,
    emagandamStart:  _slotTimes[emagSlot].$1,
    emagandamEnd:    _slotTimes[emagSlot].$2,
    kuligaiStart:    _slotTimes[kuliSlot].$1,
    kuligaiEnd:      _slotTimes[kuliSlot].$2,
    isRahuKalam:     isRahu,
    isEmagandam:     isEmag,
    isKuligai:       isKuli,
  );
}
