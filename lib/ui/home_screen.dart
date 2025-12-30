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
      onValue: (v) {
        if (mounted) {
          // برای نمایش حدود ۳ ثانیه با نرخ ۱۰۰ هرتز، ۳۰۰ نقطه نیاز داریم
          if (buffer.length > 250) buffer.removeAt(0); 
          setState(() { buffer.add(v); });
          c.updateSensor(v);
        }
      },
    ).start();
  }

  @override
  void dispose() { _sub?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Coil Counter Pro'), actions: [
        IconButton(icon: const Icon(Icons.settings), onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const SettingsSheet())),
      ]),
      body: Column(children: [
        const SizedBox(height: 20),
        Text('${c.count}', style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: c.counterColor, height: 1)),
        Text('TARGET: ${c.target}', style: const TextStyle(fontSize: 24, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SensorChart(values: buffer, threshold: c.threshold, onTap: c.setThreshold),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FloatingActionButton(onPressed: c.start, backgroundColor: Colors.green, child: const Icon(Icons.play_arrow, size: 35)),
            FloatingActionButton(onPressed: c.stop, backgroundColor: Colors.red, child: const Icon(Icons.stop, size: 35)),
            IconButton(icon: const Icon(Icons.remove_circle_outline, size: 45), onPressed: c.manualDecrement),
            IconButton(icon: const Icon(Icons.add_circle_outline, size: 45), onPressed: c.manualIncrement),
            ElevatedButton(onPressed: c.reset, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]), child: const Text('RESET')),
          ]),
        ),
      ]),
    );
  }
}
