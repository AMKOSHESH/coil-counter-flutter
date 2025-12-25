import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../core/pulse_detector.dart';

class MagnetometerSensor {
  final PulseDetector detector;
  final void Function() onPulse;
  final void Function(double) onValue;

  MagnetometerSensor({
    required this.detector,
    required this.onPulse,
    required this.onValue,
  });

  void start() {
    magnetometerEvents.listen((event) {
      final magnitude = sqrt(
        event.x * event.x +
        event.y * event.y +
        event.z * event.z,
      );

      onValue(magnitude);

      if (detector.process(magnitude)) {
        onPulse();
      }
    });
  }
}
