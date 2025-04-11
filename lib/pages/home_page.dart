import 'package:flutter/material.dart';
import 'package:flutter_buoi_2/data/database.dart';
import 'package:flutter_buoi_2/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoDatabase db = TodoDatabase();

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List filteredTodos = [];

  @override
  void initState() {
    if (db.box.get('todoList') == null) {
      db.initData();
    } else {
      db.loadData();
    }
    filteredTodos = db.todos;
    super.initState();
  }

  void _addTodo() {
    setState(() {
      db.todos.add({
        'title': titleController.text,
        'subtitle': subtitleController.text,
        'isChecked': false,
      });
      filteredTodos = db.todos;
    });
    db.updateData();
  }

  void _checkDone(int index) {
    setState(() {
      db.todos[index]['isChecked'] = !db.todos[index]['isChecked'];
      filteredTodos = db.todos;
    });
    db.updateData();
  }

  void _removeTodoWithConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  db.todos.removeAt(index);
                  filteredTodos = db.todos;
                });
                db.updateData();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editTodo({
    required int index,
    required String currentTitle,
    required String currentSubtitle,
  }) {
    titleController.text = currentTitle;
    subtitleController.text = currentSubtitle;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title...',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  hintText: 'Subtitle...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  db.todos[index]['title'] = titleController.text;
                  db.todos[index]['subtitle'] = subtitleController.text;
                  filteredTodos = db.todos;
                });
                db.updateData();
                Navigator.of(context).pop();
                titleController.clear();
                subtitleController.clear();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title...',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  hintText: 'Subtitle...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addTodo();
                Navigator.of(context).pop();
                titleController.clear();
                subtitleController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _filterTodos(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTodos = db.todos;
      } else {
        filteredTodos = db.todos
            .where((todo) =>
            todo['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterTodos,
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openDialog();
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 28),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: filteredTodos.length,
            itemBuilder: (context, index) {
              return TodoItem(
                title: filteredTodos[index]['title'],
                subtitle: filteredTodos[index]['subtitle'],
                isChecked: filteredTodos[index]['isChecked'],
                checkDone: () {
                  _checkDone(index);
                },
                removeTodo: (context) {
                  _removeTodoWithConfirmation(index);
                },
                editTodo: (context) {
                  _editTodo(
                    index: index,
                    currentTitle: filteredTodos[index]['title'],
                    currentSubtitle: filteredTodos[index]['subtitle'],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}