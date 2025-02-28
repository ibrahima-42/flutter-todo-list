import 'package:flutter/material.dart';

class TextOne extends StatefulWidget {
  // bool showComplete = false;
  TextOne({super.key});

  @override
  State<TextOne> createState() => _TextOneState();
}

class _TextOneState extends State<TextOne> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('list de taches',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}