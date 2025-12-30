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
    final c = context.read<CounterController>();
    _thresholdController = TextEditingController(text: c.threshold.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تنظیمات سنسور و هشدار', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // ۳. بارگراف تغییرات مغناطیسی زنده
          Text('مقدار لحظه‌ای سنسور: ${c.sensorValue.toStringAsFixed(1)}'),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: (c.sensorValue / 200).clamp(0, 1), // فرض بر حداکثر ۲۰۰ واحد
            minHeight: 15,
            backgroundColor: Colors.grey[800],
            color: Colors.blue,
          ),
          
          const Divider(height: 30),

          // ۱. کلید کالیبراسیون خودکار
          ElevatedButton.icon(
            onPressed: () {
              c.autoCalibrate();
              _thresholdController.text = c.threshold.toStringAsFixed(1);
            },
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('پیدا کردن خودکار سطح تریگر'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
          ),

          const SizedBox(height: 15),

          // ۲. باکس دستی سطح تریگر
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _thresholdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'سطح تریگر دستی', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final val = double.tryParse(_thresholdController.text);
                  if (val != null) c.setThreshold(val);
                },
                child: const Text('تایید'),
              ),
            ],
          ),

          const Divider(height: 40),

          // کلیدهای صدا و ویبره
          SwitchListTile(
            title: const Text('پخش صدا'),
            secondary: const Icon(Icons.volume_up),
            value: c.isSoundEnabled,
            onChanged: c.toggleSound,
          ),
          SwitchListTile(
            title: const Text('لرزش (ویبره)'),
            secondary: const Icon(Icons.vibration),
            value: c.isVibrationEnabled,
            onChanged: c.toggleVibration,
          ),
          
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green),
            child: const Text('بازگشت'),
          ),
        ],
      ),
    );
  }
}
