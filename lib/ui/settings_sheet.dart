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
  late TextEditingController _targetController;

  @override
  void initState() {
    super.initState();
    final c = context.read<CounterController>();
    _thresholdController = TextEditingController(text: c.threshold.toStringAsFixed(0));
    _targetController = TextEditingController(text: c.target.toString());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('تنظیمات دستی', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // نمایش عدد لحظه‌ای سنسور و بارگراف تریگر
            Text('Live: ${c.sensorValue.toStringAsFixed(1)} / Trigger: ${c.threshold.toStringAsFixed(0)}'),
            const SizedBox(height: 10),
            Stack(
              children: [
                LinearProgressIndicator(value: (c.sensorValue / 1000).clamp(0, 1), minHeight: 20, backgroundColor: Colors.grey[800]),
                Positioned(
                  left: (c.threshold / 1000) * MediaQuery.of(context).size.width * 0.8,
                  child: Container(width: 2, height: 20, color: Colors.red),
                )
              ],
            ),
            
            const Divider(height: 40),

            // تنظیم دستی تریگر
            TextField(
              controller: _thresholdController,
              decoration: const InputDecoration(labelText: 'سطح تریگر (µT)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (v) => c.setThreshold(double.tryParse(v) ?? c.threshold),
            ),
            
            const SizedBox(height: 20),

            // تنظیم عدد هدف
            TextField(
              controller: _targetController,
              decoration: const InputDecoration(labelText: 'تعداد دور هدف', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (v) => c.setTarget(int.tryParse(v) ?? c.target),
            ),

            const Divider(height: 30),

            Text('تاخیر پردازش: ${c.processDelayMs} ms'),
            Slider(
              value: c.processDelayMs.toDouble(),
              min: 1, max: 100,
              onChanged: (v) => c.setProcessDelay(v.toInt()),
            ),

            SwitchListTile(title: const Text('صدا'), value: c.isSoundEnabled, onChanged: c.toggleSound),
            SwitchListTile(title: const Text('ویبره'), value: c.isVibrationEnabled, onChanged: c.toggleVibration),
            
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('تایید و بازگشت')),
          ],
        ),
      ),
    );
  }
}
