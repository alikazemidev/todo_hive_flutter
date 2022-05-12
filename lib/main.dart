import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hive_db/add_todo.dart';
import 'package:note_hive_db/models/todo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  // register adapter
  Hive.registerAdapter(TodoAdapter());
  // open a new box with todo data type
  await Hive.openBox<Todo>('todos');

  await Hive.openBox('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box todoBox = Hive.box<Todo>('todos');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade900,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTodo(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Todoy'),
        backgroundColor: Colors.red[900],
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (BuildContext context, Box box, w) {
          if (box.isEmpty) {
            return Center(
              child: Text('there is no todo'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Todo todo = box.getAt(index);
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        todo.title!,
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              todo.isCompleted! ? Colors.green : Colors.black,
                          decoration: todo.isCompleted!
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        shape: CircleBorder(
                          side: BorderSide(width: 2),
                        ),
                        onChanged: (val) {
                          setState(() {
                            todo.isCompleted = val!;
                          });
                        },
                        value: todo.isCompleted,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          todoBox.deleteAt(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('todo remove'),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
