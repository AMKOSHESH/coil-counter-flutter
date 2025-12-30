import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class TargetAlert {
  final AudioPlayer _player = AudioPlayer();
  bool _playedFinal = false;

  Future<void> playBeeps(int count, double volume) async {
    await _player.setVolume(volume);
    for (int i = 0; i < count; i++) {
      await _player.play(AssetSource('beep.mp3'), mode: PlayerMode.lowLatency);
      await Future.delayed(const Duration(milliseconds: 150)); // فاصله بین بوق‌ها
    }
  }

  Future<void> check({
    required int count,
    required int target,
    required int alertDistance,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) async {
    if (!soundEnabled && !vibrationEnabled) return;

    // ۱. رسیدن به هدف (۵ بوق + ویبره)
    if (count == target && !_playedFinal) {
      _playedFinal = true;
      if (soundEnabled) await playBeeps(5, 1.0);
      if (vibrationEnabled) {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 1000);
        }
      }
      return;
    }

    // ۲. ۵ دور آخر (صدای قوی‌تر + ۲ بوق)
    if (target - count <= 5 && count < target && count > 0) {
      if (soundEnabled) await playBeeps(2, 0.8);
      return;
    }

    // ۳. دورهای عادی (صدای ضعیف + ۱ بوق)
    if (count < target && count > 0) {
      if (soundEnabled) await playBeeps(1, 0.1);
    }
  }

  void reset() {
    _playedFinal = false;
  }
}
