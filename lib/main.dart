import 'package:flutter/material.dart';
import 'result.dart';

void main() => runApp(const BasketPlanApp());

class BasketPlanApp extends StatelessWidget {
  const BasketPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Micro-Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0B5FFF),
      ),
      home: const InputPage(),
    );
  }
}

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basketball Micro-Planner'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Input page coming next...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
