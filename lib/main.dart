import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/pages/home.dart';
import 'package:todolist/pages/screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _showScreen = true;

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 5), (){
      setState(() {
        _showScreen = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _showScreen ? Screen() : Home(),
    );
  }
}