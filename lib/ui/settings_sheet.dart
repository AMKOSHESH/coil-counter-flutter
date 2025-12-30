import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/counter_controller.dart';

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});
  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    _thresholdController = TextEditingController(text: context.read<CounterController>().threshold.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.85,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Advanced Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // بارگراف تغییرات مغناطیسی
            Text('Live Signal: ${c.sensorValue.toStringAsFixed(1)} µT'),
            LinearProgressIndicator(value: (c.sensorValue / 200).clamp(0, 1), minHeight: 10),
            
            const Divider(height: 40),

            // تنظیم سرعت پردازش (تاخیر میلی‌ثانیه‌ای)
            Text('Processing Delay: ${c.processDelayMs} ms'),
            Slider(
              value: c.processDelayMs.toDouble(),
              min: 1, max: 100,
              onChanged: (v) => c.setProcessDelay(v.toInt()),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () { c.autoCalibrate(); _thresholdController.text = c.threshold.toStringAsFixed(1); },
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Auto-Calibrate Trigger'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _thresholdController,
              decoration: const InputDecoration(labelText: 'Manual Trigger Level', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onSubmitted: (v) => c.setThreshold(double.parse(v)),
            ),

            SwitchListTile(title: const Text('Sound'), value: c.isSoundEnabled, onChanged: c.toggleSound),
            SwitchListTile(title: const Text('Vibration'), value: c.isVibrationEnabled, onChanged: c.toggleVibration),
            
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('CLOSE')),
          ],
        ),
      ),
    );
  }
}
