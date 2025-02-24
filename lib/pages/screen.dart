import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Gestionnaire de taches",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )
            )
        ],
      ),
    );
  }
}