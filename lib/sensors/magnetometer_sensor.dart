import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../core/pulse_detector.dart';

class MagnetometerSensor {
  final PulseDetector detector;
  final void Function() onPulse;
  final void Function(double) onValue;
  final int intervalMs;

  MagnetometerSensor({
    required this.detector,
    required this.onPulse,
    required this.onValue,
    required this.intervalMs,
  });

  StreamSubscription start() {
    // استفاده از بالاترین سرعت ممکن سنسور در لایه سخت‌افزار
    return magnetometerEventStream(samplingPeriod: SensorInterval.fastest)
        .listen((event) {
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      onValue(magnitude);
    });
  }
}
