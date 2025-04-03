import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItemData> _todos = [
    TodoItemData(title: 'Complete Flutter project', date: '01/04/2025', isDone: false),
    TodoItemData(title: 'Read a book', date: '02/04/2025', isDone: false),
    TodoItemData(title: 'Go for a walk', date: '03/04/2025', isDone: false),
    TodoItemData(title: 'Grocery shopping', date: '04/04/2025', isDone: false),
    TodoItemData(title: 'Call mom', date: '05/04/2025', isDone: false),
    TodoItemData(title: 'Finish homework', date: '06/04/2025', isDone: false),
    TodoItemData(title: 'Clean the house', date: '07/04/2025', isDone: false),
    TodoItemData(title: 'Prepare for the meeting', date: '08/04/2025', isDone: false),
  ];

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _addTodo(String title) {
    setState(() {
      _todos.add(TodoItemData(
        title: title,
        date: '09/04/2025',
        isDone: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      backgroundColor: Colors.purple[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return TodoItem(
                    title: _todos[index].title,
                    date: _todos[index].date,
                    isDone: _todos[index].isDone,
                    onTap: () => _toggleTodo(index),
                  );
                },
              ),
            ),
            _buildAddTodoField(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTodoField() {
    TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter new task...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addTodo(controller.text);
                controller.clear();
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class TodoItemData {
  String title;
  String date;
  bool isDone;

  TodoItemData({required this.title, required this.date, required this.isDone});
}

class TodoItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isDone;
  final VoidCallback onTap;

  const TodoItem({
    required this.title,
    required this.date,
    required this.isDone,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        child: ListTile(
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.green : Colors.grey,
              key: ValueKey<bool>(isDone),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text('Created on: $date', style: TextStyle(color: Colors.grey[700])),
        ),
      ),
    );
  }
}
