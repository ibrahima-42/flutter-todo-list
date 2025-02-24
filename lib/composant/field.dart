import 'package:flutter/material.dart';

class MyField extends StatefulWidget {
  final TextEditingController controller;
  const MyField({super.key, required this.controller});

  @override
  State<MyField> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends State<MyField> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller:  widget.controller,
        decoration: const InputDecoration(  
          labelText: 'ajouter tache',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}