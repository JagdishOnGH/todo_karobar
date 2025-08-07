//call update to with copywith and bool reversed

import '../../../../core/domain/result.dart';
import '../entity/todo.dart';
import '../failure/todo_failure.dart';
import '../repository/todo_repository.dart';

class ToggleTodoUsecase {
  final TodoRepository _todoRepository;

  ToggleTodoUsecase(this._todoRepository);

  Future<Result<TodoFailure, void>> call(Todo todo) async {
    return await _todoRepository
        .updateTodo(todo.copyWith(completed: !todo.isCompleted));
  }
}
