import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/counter_controller.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();
    final targetController =
        TextEditingController(text: c.target.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Signal Level: ${c.sensorValue.toStringAsFixed(1)}'),
            LinearProgressIndicator(
              value: c.sensorValue / c.maxSensorValue,
            ),
            const SizedBox(height: 20),

            Text('Threshold: ${c.threshold.toStringAsFixed(1)}'),
            Slider(
              min: 0,
              max: c.maxSensorValue + 20,
              value: c.threshold,
              onChanged: c.setThreshold,
            ),

            Text('Debounce (ms): ${c.debounce}'),
            Slider(
              min: 10,
              max: 2000,
              divisions: 199,
              value: c.debounce.toDouble(),
              onChanged: (v) => c.setDebounce(v.toInt()),
            ),

            const Divider(),

            const Text('Target Count'),
            TextField(
              keyboardType: TextInputType.number,
              controller: targetController,
              onSubmitted: (v) {
                final n = int.tryParse(v);
                if (n != null) c.setTarget(n);
              },
            ),
          ],
        ),
      ),
    );
  }
}
