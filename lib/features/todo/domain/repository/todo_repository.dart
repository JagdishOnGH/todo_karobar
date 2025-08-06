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

  Future<Result<TodoFailure, List<Todo>>> getTodos({int limit = 50, int offset = 0});
  
  Future<Result<TodoFailure, void>> addTodo(Todo todo);

  Future<Result<TodoFailure, void>> updateTodo(Todo todo);

  Future<Result<TodoFailure, void>> deleteTodo(Todo todo);
}









