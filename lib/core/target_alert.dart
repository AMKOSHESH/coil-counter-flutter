import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class TargetAlert {
  final AudioPlayer _player = AudioPlayer();
  bool _playedFinal = false;

  TargetAlert() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> _playSound(double vol, int count) async {
    for (int i = 0; i < count; i++) {
      await _player.stop();
      await _player.setVolume(vol);
      await _player.play(AssetSource('beep.mp3'), mode: PlayerMode.lowLatency);
      if (count > 1) await Future.delayed(const Duration(milliseconds: 100));
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
      if (soundEnabled) _playSound(1.0, 5);
      if (vibrationEnabled) Vibration.vibrate(duration: 1000);
    } else if (target - count <= 5 && count < target) {
      if (soundEnabled) _playSound(0.7, 2);
    } else if (count < target) {
      if (soundEnabled) _playSound(0.15, 1);
    }
  }

  void reset() => _playedFinal = false;
}
