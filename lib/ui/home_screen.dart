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
    final counter = Provider.of<CounterController>(context, listen: false);

    MagnetometerSensor(
      detector: counter.detector,
      onPulse: counter.onPulse,
      onValue: (v) {
        if (buffer.length > 150) buffer.removeAt(0);
        setState(() {
          buffer.add(v);
        });
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
          const SizedBox(height: 20),
          Text(counter.count.toString(),
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
          const Text("Turns Detected"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SensorChart(
                values: buffer,
                threshold: counter.threshold,
                onTap: counter.setThreshold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: counter.start, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Start')),
                ElevatedButton(
                    onPressed: counter.stop, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Stop')),
                ElevatedButton(
                    onPressed: counter.reset, 
                    child: const Text('Reset')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
