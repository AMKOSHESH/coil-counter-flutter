import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/counter_controller.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Text("Threshold: ${c.threshold.toStringAsFixed(1)}"),
          Slider(
            min: 10,
            max: 200,
            value: c.threshold,
            onChanged: c.setThreshold,
          ),

          Text("Target: ${c.target}"),
          Slider(
            min: 10,
            max: 1000,
            divisions: 99,
            value: c.target.toDouble(),
            onChanged: (v) => c.setTarget(v.toInt()),
          ),

          Text("Alert distance: ${c.alertDistance}"),
          Slider(
            min: 1,
            max: 20,
            divisions: 19,
            value: c.alertDistance.toDouble(),
            onChanged: (v) => c.setAlertDistance(v.toInt()),
          ),

          const Divider(),

          DropdownButton<SensorType>(
            value: c.sensorType,
            onChanged: (v) => c.setSensorType(v!),
            items: const [
              DropdownMenuItem(
                value: SensorType.magnetometer,
                child: Text("Magnetometer"),
              ),
              DropdownMenuItem(
                value: SensorType.microphone,
                child: Text("Microphone"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
