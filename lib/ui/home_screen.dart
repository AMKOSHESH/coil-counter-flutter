import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/counter_controller.dart';
import '../sensors/magnetometer_sensor.dart';
import '../widgets/sensor_chart.dart';
import 'settings_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<double> buffer = [];
  StreamSubscription? _sensorSubscription; // برای مدیریت باتری

  @override
  void initState() {
    super.initState();
    final counter = Provider.of<CounterController>(context, listen: false);

    _sensorSubscription = MagnetometerSensor(
      detector: counter.detector,
      onPulse: counter.onPulse,
      onValue: (v) {
        if (mounted) {
          setState(() {
            if (buffer.length > 150) buffer.removeAt(0);
            buffer.add(v);
          });
          counter.updateSensor(v);
        }
      },
    ).start(); // متد start باید Subscription برگرداند
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel(); // توقف سنسور هنگام خروج برای حفظ باتری
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coil Counter Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.AutoFixHigh), // دکمه کالیبراسیون سریع
            onPressed: counter.autoCalibrate,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const SettingsSheet(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            '${counter.count} / ${counter.target}',
            style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: counter.counterColor),
          ),
          const Text('TURNS DETECTED', style: TextStyle(color: Colors.grey, letterSpacing: 2)),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SensorChart(
                values: buffer,
                threshold: counter.threshold,
                onTap: counter.setThreshold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(onPressed: counter.start, child: const Icon(Icons.play_arrow), backgroundColor: Colors.green),
                FloatingActionButton(onPressed: counter.stop, child: const Icon(Icons.stop), backgroundColor: Colors.red),
                
                // اصلاح دکمه‌های دستی
                IconButton(icon: const Icon(Icons.remove_circle_outline, size: 35), onPressed: counter.manualDecrement),
                IconButton(icon: const Icon(Icons.add_circle_outline, size: 35), onPressed: counter.manualIncrement),
                
                // اصلاح باگ دکمه Reset
                ElevatedButton(
                  onPressed: counter.reset,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                  child: const Text('RESET'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
