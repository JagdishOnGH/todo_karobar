import 'package:flutter/material.dart';

import '../../domain/entity/todo.dart';
import '../widgets/add_edit_bottom_sheet.dart';
import '../widgets/empty_widget.dart';
import '../widgets/search_bar_delegate.dart';
import '../widgets/todo_tile.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Dummy data for demonstration
  final todos = [
    Todo(
      id: 1,
      title: 'Finish Flutter UI',
      description: 'Complete the UI design and code for the todo app.',
      isCompleted: false,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    Todo(
      id: 2,
      title: 'Grocery shopping',
      description: 'Buy milk, bread, and eggs.',
      isCompleted: false,
      deadline: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Todo(
      id: 3,
      title: 'Read a book',
      description: '',
      isCompleted: true,
      deadline: DateTime.now().add(const Duration(days: 3)),
    ),
    Todo(
      id: 4,
      title: 'Go for a run',
      description: '',
      isCompleted: false,
      deadline: DateTime.now().add(const Duration(hours: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('My Tasks'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Implement filter functionality
                },
              ),
            ],
            floating: true,
            snap: true,
          ),
          SliverPersistentHeader(
            delegate: SearchBarDelegate(),
            pinned: true,
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            sliver: todos.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                      child: EmptyStateWidget(),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final todo = todos[index];
                        return TodoTile(
                          todo: todo,
                        );
                      },
                      childCount: todos.length,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ------------------- UI Components -------------------

// todo_tile.dart

// ------------------- Data Model -------------------
