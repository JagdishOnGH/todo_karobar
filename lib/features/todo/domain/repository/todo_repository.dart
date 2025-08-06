/*
[DOC] TODO Repository n interface for todo operations
 stream all todos
 add, update, toogle, delete
 str
*/



import '../../../../core/domain/result.dart';
import '../entity/todo.dart';
import '../failure/todo_failure.dart';

abstract class TodoRepository {
  /// Watches for all changes in the todo list.
  ///
  /// Returns a [Stream] of todos, which will automatically emit a new list
  /// whenever the data changes.
  ///
  /// future with default limit 50 and offset 0 to get all todos
  Future<Result<TodoFailure, List<Todo>>> getTodos();
  /// Adds a new todo to the database.
  ///
  /// Returns a [Result] which can be:
  /// - A [Success] with `void` if the operation is successful.
  /// - An [Error] containing a [DuplicateTitleFailure] if a task with the
  ///   same title already exists.
  /// - An [Error] containing a [TodoInfrastructureFailure] for other DB errors.
  Future<Result<TodoFailure, void>> addTodo(Todo todo);

  /// Updates an existing todo.
  Future<Result<TodoFailure, void>> updateTodo(Todo todo);

  /// Deletes a todo by its unique ID. Deleting by ID is more direct
  /// and efficient than passing the whole object.
  Future<Result<TodoFailure, void>> deleteTodo(int id);
}









