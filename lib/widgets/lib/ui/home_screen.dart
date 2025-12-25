import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/counter_controller.dart';
import '../sensors/magnetometer_sensor.dart';
import '../widgets/sensor_chart.dart';

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
        if (buffer.length > 150) buffer.removeAt(0);
        buffer.add(v);
        counter.updateSensorValue(v);
      },
    ).start();
  }

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Coil Counter')),
      body: Column(
        children: [
          Text(counter.count.toString(),
              style: const TextStyle(fontSize: 48)),
          Expanded(
            child: SensorChart(
              values: buffer,
              threshold: counter.threshold,
              onTap: counter.setThreshold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: counter.start, child: const Text('Start')),
              ElevatedButton(onPressed: counter.stop, child: const Text('Stop')),
              ElevatedButton(onPressed: counter.reset, child: const Text('Reset')),
            ],
          ),
        ],
      ),
    );
  }
}
