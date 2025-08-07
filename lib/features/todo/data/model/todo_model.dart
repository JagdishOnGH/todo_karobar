import 'package:floor/floor.dart';
import 'package:todo_clean_karobaar/features/todo/domain/entity/todo.dart';

@Entity(
  indices: [
    Index(
      value: ["title"],
      unique: true,
    ),
  ],
)
class TodoModel {
  //define all properties
  @PrimaryKey()
  final int id;
  @ColumnInfo(name: 'title')
  final String title;
  final String description;
  final bool completed;
  final int deadline;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.deadline,
  });

  factory TodoModel.fromTodo(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.isCompleted,
      deadline: todo.deadline.millisecondsSinceEpoch,
    );
  }

  Todo toTodo() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: completed,
      deadline: DateTime.fromMillisecondsSinceEpoch(deadline),
    );
  }
}
