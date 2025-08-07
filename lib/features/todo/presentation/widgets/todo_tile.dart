import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/todo.dart';
import '../bloc/todo_bloc/todo_bloc.dart';
import 'add_edit_bottom_sheet.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({
    super.key,
    required this.todo,
  });

  String _formatDate(DateTime date) => DateFormat.yMMMd().format(date);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = todo.deadline.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          collapsedBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          leading: IconButton(
            onPressed: () {
              context.read<TodoBloc>().add(TodoToggled(todo));
            },
            icon: Icon(
              todo.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: todo.isCompleted ? Colors.green : Colors.grey,
            ),
          ),
          title: Text(
            todo.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            if (todo.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  todo.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.schedule,
                      size: 16, color: isOverdue ? Colors.red : Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(todo.deadline),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isOverdue ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      showAddEditSheet(context, todo: todo);
                    },
                    icon: const Icon(Icons.edit_note),
                    label: const Text("Update"),
                  ),
                  FilledButton.icon(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Task"),
                            content: const Text(
                                "Are you sure you want to delete this task?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<TodoBloc>()
                                      .add(TodoDeleted(todo));
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Task deleted"),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_forever_rounded),
                    label: const Text("Delete"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
