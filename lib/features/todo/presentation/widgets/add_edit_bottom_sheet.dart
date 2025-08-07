import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/todo.dart';
import '../bloc/todo_bloc/todo_bloc.dart';

class AddEditTodoBottomSheet extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoBottomSheet({super.key, this.todo});

  @override
  State<AddEditTodoBottomSheet> createState() => _AddEditTodoBottomSheetState();
}

class _AddEditTodoBottomSheetState extends State<AddEditTodoBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
    _selectedDeadline = widget.todo?.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDeadline ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.todo == null ? 'New Task' : 'Edit Task',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectDeadline(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDeadline != null
                      ? '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year} ${_selectedDeadline!.hour}:${_selectedDeadline!.minute}'
                      : 'Select a deadline',
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final newTodo = Todo(
                    id: widget.todo?.id ??
                        DateTime.now().millisecondsSinceEpoch,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    deadline: _selectedDeadline ?? DateTime.now(),
                    isCompleted: widget.todo?.isCompleted ?? false,
                  );

                  if (widget.todo != null) {
                    context.read<TodoBloc>().add(
                          TodoUpdated(newTodo),
                        );
                  } else {
                    context.read<TodoBloc>().add(
                          TodoAdded(newTodo),
                        );
                  }
                  Navigator.pop(context, newTodo);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Save Task'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

void showAddEditSheet(BuildContext context, {Todo? todo}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AddEditTodoBottomSheet(todo: todo);
    },
  );
}
