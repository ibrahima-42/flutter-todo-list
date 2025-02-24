import 'package:flutter/material.dart';

class NewTask extends StatelessWidget {
  const NewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: const Text("nouvelle tache",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
    );
  }
}
