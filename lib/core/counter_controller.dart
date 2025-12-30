import 'package:flutter/material.dart';
import 'pulse_detector.dart';
import 'target_alert.dart';

class CounterController extends ChangeNotifier {
  int count = 0;
  bool running = false;
  double threshold = 70.0;
  int target = 100;
  int processDelayMs = 1; // تنظیم دستی سرعت پردازش از ۱ میلی‌ثانیه

  bool isSoundEnabled = true;
  bool isVibrationEnabled = true;

  double sensorValue = 0;
  double maxDetectedValue = 0.0;
  DateTime _lastProcessTime = DateTime.now();

  late PulseDetector detector;
  final TargetAlert alert = TargetAlert();

  CounterController() { _rebuild(); }

  void _rebuild() {
    detector = PulseDetector(highThreshold: threshold, lowThreshold: threshold * 0.8, debounceMs: 50);
  }

  void updateSensor(double v) {
    sensorValue = v;
    if (v > maxDetectedValue) maxDetectedValue = v;

    final now = DateTime.now();
    // اعمال فیلتر سرعت بر اساس میلی‌ثانیه انتخابی کاربر
    if (now.difference(_lastProcessTime).inMilliseconds >= processDelayMs) {
      if (detector.process(v)) {
        onPulse();
      }
      _lastProcessTime = now;
      notifyListeners();
    }
  }

  void onPulse() {
    if (!running) return;
    count++;
    alert.check(count: count, target: target, soundEnabled: isSoundEnabled, vibrationEnabled: isVibrationEnabled);
    notifyListeners();
  }

  void setProcessDelay(int ms) { processDelayMs = ms; notifyListeners(); }
  void autoCalibrate() { 
    if (maxDetectedValue > 5) { 
      threshold = maxDetectedValue * 0.75; 
      _rebuild(); 
      notifyListeners(); 
    } 
  }
  
  void setThreshold(double v) { threshold = v; _rebuild(); notifyListeners(); }
  void setTarget(int v) { target = v; notifyListeners(); }
  void toggleSound(bool v) { isSoundEnabled = v; notifyListeners(); }
  void toggleVibration(bool v) { isVibrationEnabled = v; notifyListeners(); }
  
  void start() { running = true; notifyListeners(); }
  void stop() { running = false; notifyListeners(); }
  void reset() { count = 0; maxDetectedValue = 0; alert.reset(); notifyListeners(); }
  
  void manualIncrement() { count++; notifyListeners(); }
  void manualDecrement() { if (count > 0) count--; notifyListeners(); }

  Color get counterColor => (count >= target) ? Colors.red : (target - count <= 5 ? Colors.orange : Colors.white);
}
