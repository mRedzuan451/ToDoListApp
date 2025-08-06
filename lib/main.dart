import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoListApp());
}

// A simple class to represent the data for a single to-do item.
class ToDoItem {
  String title;
  bool isDone;

  ToDoItem({required this.title, this.isDone = false});
}

// The main application widget. It's stateless because the state
// is managed by the ToDoListScreen.
class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Add a bit of modern flair with Material 3
        useMaterial3: true,
      ),
      // Set the home screen of the app
      home: const ToDoListScreen(),
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}

// The main screen widget, which is stateful because the list of tasks will change.
class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

// This is the State class that holds the logic and UI for our screen.
class _ToDoListScreenState extends State<ToDoListScreen> {
  // The list that holds all our to-do items. This is our "state".
  final List<ToDoItem> _tasks = [];
  
  // Controller to get the text from the TextField in the dialog.
  final TextEditingController _textFieldController = TextEditingController();

  // This function is called when the user taps the "Add" button in the dialog.
  void _addTask(String title) {
    // We call setState to notify Flutter that our state has changed.
    // This will trigger a rebuild of the widget tree, updating the UI.
    setState(() {
      _tasks.add(ToDoItem(title: title));
    });
    // Clear the text field for the next entry.
    _textFieldController.clear();
    // Close the dialog.
    Navigator.of(context).pop();
  }

  // This function is called when the user taps the checkbox.
  void _toggleTask(ToDoItem task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  // This function is called when the user taps the delete icon.
  void _deleteTask(ToDoItem task) {
    setState(() {
      _tasks.remove(task);
    });
  }
  
  // This function displays the dialog for adding a new task.
  Future<void> _showAddTaskDialog() async {
    return showDialog<void>(
      context: context,
      // The user must tap a button to dismiss the dialog.
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: _textFieldController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task here...'),
            // Allows submitting with the Enter key
            onSubmitted: (value) => _addTask(value),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Clear the text field before closing.
                _textFieldController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_textFieldController.text.isNotEmpty) {
                  _addTask(_textFieldController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold widget provides the basic structure of the visual interface.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter To-Do List'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      // The body contains the main content of the screen.
      body: ListView.builder(
        // The number of items in the list.
        itemCount: _tasks.length,
        // The builder function is called for each item in the list.
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            // The leading widget is a Checkbox.
            leading: Checkbox(
              value: task.isDone,
              onChanged: (value) => _toggleTask(task),
            ),
            // The title of the list tile is the task's title.
            title: Text(
              task.title,
              // Apply a strikethrough style if the task is done.
              style: TextStyle(
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color: task.isDone ? Colors.grey : null,
              ),
            ),
            // The trailing widget is a delete button.
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTask(task),
            ),
          );
        },
      ),
      // The FloatingActionButton is used to add new tasks.
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
