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
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    final c = context.read<CounterController>();
    _sub = MagnetometerSensor(
      detector: c.detector,
      onPulse: c.onPulse,
      onValue: (v) {
        if (mounted) {
          setState(() {
            if (buffer.length > 150) buffer.removeAt(0);
            buffer.add(v);
          });
          c.updateSensor(v);
        }
      },
    ).start();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coil Counter Pro'),
        actions: [
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
          const SizedBox(height: 40),
          Text(
            '${c.count}',
            style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: c.counterColor),
          ),
          Text('GOAL: ${c.target}', style: const TextStyle(fontSize: 20, color: Colors.grey)),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SensorChart(values: buffer, threshold: c.threshold, onTap: c.setThreshold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(onPressed: c.start, backgroundColor: Colors.green, child: const Icon(Icons.play_arrow)),
                FloatingActionButton(onPressed: c.stop, backgroundColor: Colors.red, child: const Icon(Icons.stop)),
                IconButton(icon: const Icon(Icons.remove_circle_outline, size: 40), onPressed: c.manualDecrement),
                IconButton(icon: const Icon(Icons.add_circle_outline, size: 40), onPressed: c.manualIncrement),
                ElevatedButton(onPressed: c.reset, child: const Text('RESET')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
