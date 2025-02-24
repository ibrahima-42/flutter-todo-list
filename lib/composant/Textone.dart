import 'package:flutter/material.dart';

class TextOne extends StatelessWidget {
  const TextOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'list de taches',
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      );
  }
}