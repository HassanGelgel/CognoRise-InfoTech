import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _textController = TextEditingController();
  List<List<dynamic>> todo = [];

  void _addTask() {
    final task = _textController.text.trim();
    if (task.isNotEmpty) {
      setState(() {
        todo.insert(0, [task, false, false]);
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.deepPurple.shade200,
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(
              "SIMPLE TODO APP",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: 'All Tasks'),
                Tab(text: 'Starred Tasks'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTaskList(false),
                    _buildTaskList(true),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              color: Colors.deepPurple.shade300,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        labelText: 'Enter a new task',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(bool starred) {
    List<List<dynamic>> tasks = todo.where((task) => task[2] == starred).toList();

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          starred ? 'No Starred Tasks' : 'No Tasks Yet',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, index) {
        final taskIndex = todo.indexOf(tasks[index]);
        return Dismissible(
          key: Key(todo[taskIndex][0]),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              bool? confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Are you sure you want to delete this task?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text("Delete"),
                      ),
                    ],
                  );
                },
              );
              return confirm;
            }
            return false;
          },
          onDismissed: (direction) {
            setState(() {
              todo.removeAt(taskIndex);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: (todo[taskIndex][1] == false)
                    ? Colors.deepPurple
                    : Colors.deepPurple.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(width: 5),
                  Container(
                    color: Colors.deepPurple.shade300,
                    width: 19,
                    height: 19,
                    child: Checkbox(
                      value: todo[taskIndex][1],
                      onChanged: (val) {
                        setState(() {
                          todo[taskIndex][1] = val;
                        });
                      },
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      todo[taskIndex][0],
                      style: TextStyle(
                          color: Colors.white, // Text color
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: (todo[taskIndex][1] == true)
                              ? TextDecoration.lineThrough
                              : null,
                          decorationThickness: 4),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      todo[taskIndex][2] ? Icons.star : Icons.star_border,
                      color: todo[taskIndex][2] ? Colors.yellow : Colors.grey,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: (todo[index][2])==true?Text("This Task Moved To Starred Tasks successfully!"):Text('This Task Removed From Starred successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("OK"),
                              ),

                            ],
                          );
                        },
                      );
                      setState(() {
                        todo[taskIndex][2] = !todo[taskIndex][2];
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
