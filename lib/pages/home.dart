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
  bool _showComplete = false;

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
        print(tasks);
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
    final delete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('supprimer tache'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            } ,
            child: Text('supprimer',style: TextStyle(color: Colors.red),),
          ),
        ],
      )
      );
      if(delete == true){
        final realIndex = tasks.indexOf(tasks[index]);
        setState(() {
          tasks.removeAt(realIndex);
          _saveTask();
        });
      }
  }

  //function pour afficher les taches complete ou non complete
  List<Map<String, dynamic>> getCompleteTask() {
    return tasks.where((task) => task['complete'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayTask = _showComplete ? getCompleteTask() : tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion taches"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showComplete = !_showComplete;
              });
            },
            icon: Icon(_showComplete ? Icons.check_circle : Icons.list),
          ),
        ],
      ),

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
                          Text(
                            "Nouvelle tâche",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                              child: Center(
                                child: const Text(
                                  "Ajouter",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                child: Row(
                  children: [
                    const Text(
                      "nouvelle tache",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.edit_document, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(height: 3, width: double.infinity, color: Colors.grey),
            SizedBox(height: 10),
            _showComplete
                ? Text(
                  'Tache Complete',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
                : TextOne(),
            Expanded(
              child: ListView.builder(
                itemCount: displayTask.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      activeColor: Colors.blue,
                      value: displayTask[index]['complete'],
                      onChanged: (value) {
                        setState(() {
                          int realIdex = tasks.indexOf(displayTask[index]);
                          if (realIdex != -1) {
                            setState(() {
                              tasks[realIdex]['complete'] = value ?? false;
                              _saveTask();
                            });
                          }
                        });
                      },
                    ),
                    title:
                        _showComplete
                            ? Text(
                              displayTask[index]['tache'],
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            )
                            : Text(
                              tasks[index]['tache'] ?? "Tâche vide",
                              style: TextStyle(
                                decoration:
                                    displayTask[index]['complete'] ?? false
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                color:
                                    displayTask[index]['complete'] ?? false
                                        ? Colors.grey
                                        : Colors.black,
                              ),
                            ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
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
