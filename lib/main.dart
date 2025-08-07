import 'package:flutter/material.dart';

import 'features/todo/presentation/pages/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue.shade700,
        brightness: Brightness.light,
      ),
      home: const TodoListPage(),
    );
  }
}
