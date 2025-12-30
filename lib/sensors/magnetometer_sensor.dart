import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerSensor {
  final void Function(double) onValue;

  MagnetometerSensor({required this.onValue});

  StreamSubscription start() {
    // استفاده از کمترین تاخیر ممکن (صفر) برای رسیدن به حداکثر سرعت سخت‌افزار
    return magnetometerEventStream(samplingPeriod: Duration.zero)
        .listen((event) {
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      onValue(magnitude);
    });
  }
}
