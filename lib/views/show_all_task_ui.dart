import 'package:flutter/material.dart';
import 'package:flutter_task_v1_app/views/add_task_ui.dart';

class ShowAllTaskUi extends StatefulWidget {
  const ShowAllTaskUi({super.key});

  @override
  State<ShowAllTaskUi> createState() => _ShowAllTaskUiState();
}

class _ShowAllTaskUiState extends State<ShowAllTaskUi> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Task Na Ja V1',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskUi(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
import 'package:flutter/material.dart';

class AddTaskUi extends StatefulWidget {
  const AddTaskUi({super.key});

  @override
  State<AddTaskUi> createState() => _AddTaskUiState();
}

class _AddTaskUiState extends State<AddTaskUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Task Na Ja V1 (Add Task)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
    );
  }
}
 [W00T], 
ตาฟลุ๊ค [W00T],  — 15:14
c
ตาบอม [ASS],  — 15:14
 lua import 'package:flutter/material.dart';

class ShowAllTaskUi extends StatefulWidget {
  const ShowAllTaskUi({super.key});

  @override
  State<ShowAllTaskUi> createState() => _ShowAllTaskUiState();
}

class _ShowAllTaskUiState extends State<ShowAllTaskUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}