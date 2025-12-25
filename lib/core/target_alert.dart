import 'package:audioplayers/audioplayers.dart';

class TargetAlert {
  final AudioPlayer _player = AudioPlayer();
  bool enabled = true;

  Future<void> check({
    required int count,
    required int target,
    required int alertDistance,
  }) async {
    if (!enabled) return;
    if (count >= target) return;

    final remaining = target - count;

    if (remaining <= alertDistance) {
      final volume =
          (alertDistance - remaining + 1) / alertDistance;
      await _player.setVolume(volume.clamp(0.1, 1.0));
      await _player.play(AssetSource('beep.mp3'));
    }
  }
}
