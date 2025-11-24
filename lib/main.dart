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

class Drill {
  final String name;
  final int minutes;
  final String note;
  final IconData icon;

  const Drill({
    required this.name,
    required this.minutes,
    required this.note,
    required this.icon,
  });

  @override
  String toString() => '$name - $minutes min';
}

enum Difficulty { easy, medium, hard }

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _minutesController = TextEditingController();
  String _focus = 'Handles';
  Difficulty _difficulty = Difficulty.medium;

  final List<String> _focusOptions = const [
    'Handles',
    'Shooting',
    'Defense',
    'Conditioning',
  ];

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text('Basketball Micro-Planner'),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Build a Session',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text(
                  'Pick a focus, difficulty, and time.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          TextField(
            controller: _minutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutes available',
              prefixIcon: Icon(Icons.timer_outlined),
              hintText: 'e.g. 45',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _focus,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _focusOptions
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) => setState(() => _focus = val!),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Difficulty',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                RadioListTile<Difficulty>(
                  title: const Text('Easy'),
                  value: Difficulty.easy,
                  groupValue: _difficulty,
                  onChanged: (v) => setState(() => _difficulty = v!),
                ),
                RadioListTile<Difficulty>(
                  title: const Text('Medium'),
                  value: Difficulty.medium,
                  groupValue: _difficulty,
                  onChanged: (v) => setState(() => _difficulty = v!),
                ),
                RadioListTile<Difficulty>(
                  title: const Text('Hard'),
                  value: Difficulty.hard,
                  groupValue: _difficulty,
                  onChanged: (v) => setState(() => _difficulty = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
