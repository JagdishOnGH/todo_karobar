/*
[DOC] TODO Entity n title, description, completed status and deadline - independent of outer-layer
*/

class Todo {
 final int id;
  final String title;
  final String description;
  final bool completed;
  final DateTime deadline;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.deadline,
  });


  //copyWith
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? deadline,
  }) {
    return Todo(title: title ?? this.title, id: id ?? this.id, description: description ?? this.description, completed: completed ?? this.completed, deadline: deadline ?? this.deadline);
  }
}