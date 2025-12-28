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

  @override
  void initState() {
    super.initState();

    final counter =
        Provider.of<CounterController>(context, listen: false);

    MagnetometerSensor(
      detector: counter.detector,
      onPulse: counter.onPulse,
      onValue: (v) {
        if (buffer.length > 200) {
          buffer.removeAt(0);
        }
        buffer.add(v);
        counter.updateSensor(v);
      },
    ).start();
  }

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coil Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const SettingsSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          /// شمارنده اصلی + هدف
          Text(
            '${counter.count} / ${counter.target}',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: counter.counterColor,
            ),
          ),
Padding(
  padding: const EdgeInsets.only(top: 8, right: 12),
  child: Align(
    alignment: Alignment.topRight,
    child: Text(
      'Total: ${counter.target}',
      style: const TextStyle(fontSize: 20),
    ),
  ),
),

          const SizedBox(height: 8),
          const Text(
            'TOTAL TURNS',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          /// نمودار سیگنال
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

          const SizedBox(height: 10),

          /// دکمه‌ها

Padding(
  padding: const EdgeInsets.only(bottom: 30),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton(
        onPressed: counter.start,
        child: const Text('START'),
      ),
      ElevatedButton(
        onPressed: counter.stop,
        child: const Text('STOP'),
      ),
      IconButton(
        icon: const Icon(Icons.remove_circle, size: 36),
        onPressed: counter.manualDecrement,
      ),
      IconButton(
        icon: const Icon(Icons.add_circle, size: 36),
        onPressed: counter.manualIncrement,
      ),
      ElevatedButton(
        onPressed: counter.reset,
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
