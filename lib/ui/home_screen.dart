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
        buffer.add(v);
        // حالا این متد وجود دارد و خطا نمی‌دهد
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
          const SizedBox(height: 50),
          Text('${counter.count}', style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold)),
          const Text("TURNS", style: TextStyle(letterSpacing: 4)),
          const SizedBox(height: 20),
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
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(onPressed: counter.start, child: const Icon(Icons.play_arrow), backgroundColor: Colors.green),
                FloatingActionButton(onPressed: counter.stop, child: const Icon(Icons.stop), backgroundColor: Colors.red),
                FloatingActionButton(onPressed: counter.reset, child: const Icon(Icons.refresh)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
