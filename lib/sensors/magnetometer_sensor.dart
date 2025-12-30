import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerSensor {
  final void Function(double) onValue;

  MagnetometerSensor({required this.onValue});

  StreamSubscription start() {
    // استفاده از بالاترین نرخ خروجی سخت‌افزار
    return magnetometerEventStream(samplingPeriod: SensorInterval.fastest)
        .listen((event) {
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      onValue(magnitude);
    });
  }
}
