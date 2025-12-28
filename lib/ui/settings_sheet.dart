import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/counter_controller.dart';

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late TextEditingController targetController;

  @override
  void initState() {
    super.initState();
    final c = context.read<CounterController>();
    targetController =
        TextEditingController(text: c.target.toString());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Debounce (ms): ${c.debounce}'),
          Slider(
            min: 10,
            max: 2000,
            divisions: 199,
            value: c.debounce.toDouble(),
            onChanged: (v) => c.setDebounce(v.toInt()),
          ),

          const Divider(),

          const Text('Target (1 تا 9999)'),
          TextField(
            controller: targetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'مثلاً 120',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final v = int.tryParse(targetController.text);
              if (v != null && v >= 1 && v <= 9999) {
                c.setTarget(v);
              }
            },
            child: const Text('Apply Target'),
          ),
        ],
      ),
    );
  }
}
