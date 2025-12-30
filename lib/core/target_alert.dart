import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class TargetAlert {
  final AudioPlayer _player = AudioPlayer();
  bool _playedFinal = false;

  // تابع کمکی برای پخش تعداد مشخص بوق با بلندی صدای معین
  Future<void> _playMultiBeep(int times, double volume) async {
    await _player.setVolume(volume);
    for (int i = 0; i < times; i++) {
      await _player.play(AssetSource('beep.mp3'), mode: PlayerMode.lowLatency);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> check({
    required int count,
    required int target,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) async {
    if (count <= 0) return;

    // ۱. رسیدن به هدف: ۵ بوق + ویبره قوی
    if (count >= target && !_playedFinal) {
      _playedFinal = true;
      if (soundEnabled) await _playMultiBeep(5, 1.0);
      if (vibrationEnabled) {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 1000);
        }
      }
      return;
    }

    // ۲. ۵ دور آخر: ۲ بوق بلندتر
    if (target - count <= 5 && count < target) {
      if (soundEnabled) await _playMultiBeep(2, 0.8);
      return;
    }

    // ۳. دورهای عادی: ۱ بوق خیلی ضعیف
    if (count < target) {
      if (soundEnabled) {
        await _player.setVolume(0.1);
        await _player.play(AssetSource('beep.mp3'), mode: PlayerMode.lowLatency);
      }
    }
  }

  void reset() {
    _playedFinal = false;
  }
}
