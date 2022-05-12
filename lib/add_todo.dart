import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hive_db/models/todo.dart';

class AddTodo extends StatelessWidget {
  TextEditingController title = TextEditingController();
  Box todoBox = Hive.box<Todo>('todos');
  AddTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Add New Todo'),
        backgroundColor: Colors.red[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red.shade900,
                ),
                onPressed: () {
                  if (title.text.isNotEmpty) {
                    Todo newTodo = Todo(
                      title: title.text,
                      isCompleted: false,
                    );
                    todoBox.add(newTodo);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Add Todo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
