import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Session')),
      body: const Center(
        child: Text(
          'Results page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
