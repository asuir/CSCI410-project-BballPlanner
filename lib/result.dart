import 'package:flutter/material.dart';
import 'main.dart';


class ResultPage extends StatelessWidget {
  final TrainingPlan plan;
  const ResultPage({super.key, required this.plan});

  String diffLabel(Difficulty d) => switch (d) {
    Difficulty.easy => 'Easy',
    Difficulty.medium => 'Medium',
    Difficulty.hard => 'Hard',
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text('Your Session'),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: cs.primary.withOpacity(0.12),
                  child: Icon(Icons.sports_basketball, color: cs.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.focus,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.minutes} min • ${diffLabel(plan.difficulty)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Load Score', style: TextStyle(color: Colors.black54)),
                    Text(
                      plan.loadScore.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Drills',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),

          // Drills list
          ...plan.drills.map((d) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cs.secondary.withOpacity(0.12),
                    child: Icon(d.icon, color: cs.secondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text(d.note, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${d.minutes}m',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          // Back button
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Edit'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
