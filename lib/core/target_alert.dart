import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class TargetAlert {
  late AudioPlayer _player;
  bool _playedFinal = false;

  TargetAlert() {
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> _play(double volume, {int repeats = 1}) async {
    for (int i = 0; i < repeats; i++) {
      await _player.stop(); // توقف بوق قبلی برای پخش سریع‌تر بعدی
      await _player.setVolume(volume);
      await _player.play(AssetSource('beep.mp3'), mode: PlayerMode.lowLatency);
      if (repeats > 1) await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  Future<void> check({
    required int count,
    required int target,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) async {
    if (count <= 0) return;

    if (count >= target && !_playedFinal) {
      _playedFinal = true;
      if (soundEnabled) _play(1.0, repeats: 5);
      if (vibrationEnabled) Vibration.vibrate(duration: 1000);
      return;
    }

    if (target - count <= 5 && count < target) {
      if (soundEnabled) _play(0.8, repeats: 2);
    } else if (count < target) {
      if (soundEnabled) _play(0.1, repeats: 1);
    }
  }

  void reset() => _playedFinal = false;
}
