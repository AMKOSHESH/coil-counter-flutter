import 'package:audioplayers/audioplayers.dart';

class TargetAlert {
  final AudioPlayer _player = AudioPlayer();
  bool _playedFinal = false;

  Future<void> check({
    required int count,
    required int target,
    required int alertDistance,
  }) async {
    if (count >= target && !_playedFinal) {
      _playedFinal = true;
      await _player.play(AssetSource('beep.mp3'));
      return;
    }

    if (target - count <= alertDistance && count < target) {
      final volume =
          (alertDistance - (target - count) + 1) / alertDistance;
      await _player.setVolume(volume.clamp(0.2, 1.0));
      await _player.play(AssetSource('beep.mp3'));
    }
  }

  void reset() {
    _playedFinal = false;
  }
}
