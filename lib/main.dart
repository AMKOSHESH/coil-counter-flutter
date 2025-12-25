import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/counter_controller.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coil Counter',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
