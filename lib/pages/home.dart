import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/composant/Textone.dart';
import 'package:todolist/composant/field.dart';
import 'package:todolist/composant/newtask.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> tasks = [];

  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeask(); //charger les taches sauvegarder au demarage
  }

  //function pour charger les taches sauvegarder au demarage,
  Future<void> _loadTeask() async {
    final data = await SharedPreferences.getInstance();
    final String? taches = data.getString('tasks');
    if (taches != null) {
      setState(() {
        tasks = List<Map<String, dynamic>>.from(json.decode(taches));
      });
    }
  }

  //function pour ajouter un taches
  void _addTask() {
    setState(() {
      tasks.add({"tache": _taskController.text.trim(), "complete": false});
      _saveTask();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('tache ajouter', style: TextStyle(color: Colors.white)),
        ),
      );
      _taskController.clear();
    });
  }

  //function pour sauvegarder un taches
  Future<void> _saveTask() async {
    final task = await SharedPreferences.getInstance();
    await task.setString('tasks', jsonEncode(tasks));
  }

  //function pour supprimer un taches
  Future<void> _deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
      _saveTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("taches")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 170,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Nouvelle tâche", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                          MyField(controller: _taskController),
                          GestureDetector(
                            onTap: () {
                              _addTask();
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              child: Center(child: const Text("Ajouter",style: TextStyle(color: Colors.white),)),
                            ),
                          )
                        ]
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: const Text("nouvelle tache",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 16),
            Container(height: 3, width: double.infinity, color: Colors.grey),
            SizedBox(height: 10),
            TextOne(),
            // Row(
            //   children: [
            //     MyField(controller: _taskController),
            //     TextButton(
            //       onPressed: () {
            //         _addTask();
            //       },
            //       child: Icon(Icons.add),
            //     ),
            //   ],
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: tasks[index]['complete'],
                      onChanged: (value) {
                        setState(() {
                          tasks[index]['complete'] = value ?? false;
                          _saveTask();
                        });
                      },
                    ),
                    title: Text(
                      tasks[index]['tache'] ?? "Tâche vide",
                      style: TextStyle(
                        decoration:
                            (tasks[index]['complete'] ?? false
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                    // Vérifie null et évite l'erreur
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
