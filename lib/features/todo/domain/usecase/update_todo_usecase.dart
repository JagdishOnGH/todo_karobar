//update todo usecase


import '../../../../core/domain/result.dart';
import '../entity/todo.dart';
import '../failure/todo_failure.dart';
import '../repository/todo_repository.dart';

class UpdateTodoUsecase {
  final TodoRepository _todoRepository;

  UpdateTodoUsecase(this._todoRepository);

  Future<Result<TodoFailure, void>> call(Todo todo) async {
    return await _todoRepository.updateTodo(todo);
  }
}
