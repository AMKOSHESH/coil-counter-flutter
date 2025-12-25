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
      onValue: counter.updateSensor,
    ).start();
  }

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coil Counter Pro'),
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
          const SizedBox(height: 40),
          Text(
            '${counter.count}',
            style: const TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text("TOTAL TURNS",
              style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SensorChart(
                values: buffer,
                threshold: counter.threshold,
                onTap: counter.setThreshold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: counter.start,
                    child: const Text('START')),
                ElevatedButton(
                    onPressed: counter.stop,
                    child: const Text('STOP')),
                ElevatedButton(
                    onPressed: counter.reset,
                    child: const Text('RESET')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
