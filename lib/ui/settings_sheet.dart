import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/counter_controller.dart';

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});
  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late TextEditingController _targetController;
  late TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    final c = context.read<CounterController>();
    _targetController = TextEditingController(text: c.target.toString());
    _thresholdController = TextEditingController(text: c.threshold.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('Advanced Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 25),

            // ۳. بارگراف زنده مغناطیسی
            Text('Live Sensor: ${c.sensorValue.toStringAsFixed(1)} µT', style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (c.sensorValue / 200).clamp(0, 1),
                minHeight: 12,
                backgroundColor: Colors.white10,
                color: Colors.blueAccent,
              ),
            ),
            
            const Divider(height: 40, color: Colors.white24),

            // ۱. دکمه کالیبراسیون خودکار
            ElevatedButton.icon(
              onPressed: () {
                c.autoCalibrate();
                _thresholdController.text = c.threshold.toStringAsFixed(1);
              },
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Auto-Find Trigger Level'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueGrey[800],
              ),
            ),

            const SizedBox(height: 20),

            // ۲. تنظیم دستی سطح تریگر
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _thresholdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Manual Trigger (µT)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final val = double.tryParse(_thresholdController.text);
                    if (val != null) c.setThreshold(val);
                  },
                  child: const Text('SET'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // تنظیم عدد هدف
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Turns', border: OutlineInputBorder()),
              onChanged: (v) {
                final val = int.tryParse(v);
                if (val != null) c.setTarget(val);
              },
            ),

            const Divider(height: 40, color: Colors.white24),

            // تنظیمات صدا و ویبره
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: c.isSoundEnabled,
              onChanged: c.toggleSound,
              secondary: const Icon(Icons.volume_up),
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: c.isVibrationEnabled,
              onChanged: c.toggleVibration,
              secondary: const Icon(Icons.vibration),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.green,
              ),
              child: const Text('DONE / BACK'),
            ),
          ],
        ),
      ),
    );
  }
}
