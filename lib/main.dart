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

  void _generatePlan() {
    final raw = _minutesController.text.trim();
    final minutes = int.tryParse(raw);

    if (minutes == null || minutes < 10 || minutes > 180) {
      _showError('Enter minutes between 10 and 180.');
      return;
    }

    final plan = PlanGenerator.generate(
      focus: _focus,
      minutes: minutes,
      difficulty: _difficulty,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(plan: plan),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
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
              onPressed: _generatePlan,
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

class TrainingPlan {
  final String focus;
  final Difficulty difficulty;
  final int minutes;
  final double loadScore;
  final List<Drill> drills;

  TrainingPlan({
    required this.focus,
    required this.difficulty,
    required this.minutes,
    required this.loadScore,
    required this.drills,
  });
}

class PlanGenerator {
  static TrainingPlan generate({
    required String focus,
    required int minutes,
    required Difficulty difficulty,
  }) {
    final mult = switch (difficulty) {
      Difficulty.easy => 1.0,
      Difficulty.medium => 1.3,
      Difficulty.hard => 1.6,
    };

    final focusPool = _drillPoolForFocus(focus);

    final drillCount = minutes <= 25
        ? 3
        : minutes <= 45
        ? 4
        : minutes <= 70
        ? 5
        : 6;

    final selected = focusPool.take(drillCount).toList();

    final base = (minutes / drillCount).floor();
    int remainder = minutes - base * drillCount;

    final drills = <Drill>[];
    for (final d in selected) {
      final add = remainder > 0 ? 1 : 0;
      if (remainder > 0) remainder--;

      drills.add(
        Drill(
          name: d.name,
          minutes: base + add,
          note: d.note,
          icon: d.icon,
        ),
      );
    }

    final loadScore = minutes * mult;

    return TrainingPlan(
      focus: focus,
      difficulty: difficulty,
      minutes: minutes,
      loadScore: loadScore,
      drills: drills,
    );
  }

  static List<Drill> _drillPoolForFocus(String focus) {
    switch (focus) {
      case 'Handles':
        return const [
          Drill(name: 'Stationary Pound Dribbles', minutes: 0, note: 'Low + hard reps', icon: Icons.sports_basketball),
          Drill(name: 'Cross / Between / Behind Combo', minutes: 0, note: 'Stay relaxed', icon: Icons.sync_alt),
          Drill(name: 'Cone Slalom Dribble', minutes: 0, note: 'Eyes up', icon: Icons.construction),
          Drill(name: 'Change-of-Pace Drives', minutes: 0, note: 'Explode out of moves', icon: Icons.flash_on),
          Drill(name: 'Two-Ball Dribbling', minutes: 0, note: 'Control both hands', icon: Icons.all_inclusive),
          Drill(name: 'Finishing Series', minutes: 0, note: 'Footwork focus', icon: Icons.directions_run),
        ];
      case 'Shooting':
        return const [
          Drill(name: 'Form Shooting Close Range', minutes: 0, note: 'Perfect mechanics', icon: Icons.my_location),
          Drill(name: 'Midrange Spots (5 spots)', minutes: 0, note: 'Game speed', icon: Icons.place),
          Drill(name: 'Catch-and-Shoot', minutes: 0, note: 'Quick feet set', icon: Icons.sports_handball),
          Drill(name: 'Off-Dribble Pull-ups', minutes: 0, note: '1–2 stop', icon: Icons.timeline),
          Drill(name: 'Free Throw Routine', minutes: 0, note: 'Same ritual', icon: Icons.check_circle_outline),
          Drill(name: 'Conditioned Shooting', minutes: 0, note: 'Shoot while tired', icon: Icons.favorite_border),
        ];
      case 'Defense':
        return const [
          Drill(name: 'Slide & Recover', minutes: 0, note: 'Low stance', icon: Icons.swap_horiz),
          Drill(name: 'Closeout Technique', minutes: 0, note: 'Hands high', icon: Icons.open_in_full),
          Drill(name: 'Mirror Footwork', minutes: 0, note: 'React fast', icon: Icons.visibility),
          Drill(name: 'Zig-Zag Containment', minutes: 0, note: 'Cut angles', icon: Icons.route),
          Drill(name: 'Box-out Reps', minutes: 0, note: 'Hit then get', icon: Icons.shield_outlined),
          Drill(name: 'Steal Timing', minutes: 0, note: 'Don’t reach', icon: Icons.timer),
        ];
      default:
        return const [
          Drill(name: 'Court Sprints', minutes: 0, note: 'Full speed', icon: Icons.speed),
          Drill(name: 'Suicides (lines)', minutes: 0, note: 'Touch every line', icon: Icons.show_chart),
          Drill(name: 'Defensive Slides Intervals', minutes: 0, note: '20s on / 10s off', icon: Icons.swap_calls),
          Drill(name: 'Jump Rope / High Knees', minutes: 0, note: 'Stay light', icon: Icons.fitness_center),
          Drill(name: 'Core Circuit', minutes: 0, note: 'Plank + twists', icon: Icons.self_improvement),
          Drill(name: 'Cool-down Mobility', minutes: 0, note: 'Stretch hips/ankles', icon: Icons.spa),
        ];
    }
  }
}

