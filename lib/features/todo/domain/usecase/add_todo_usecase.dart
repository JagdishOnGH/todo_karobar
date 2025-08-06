import '../../../../core/domain/result.dart';
import '../entity/todo.dart';
import '../failure/todo_failure.dart';
import '../repository/todo_repository.dart';

class AddTodoUsecase {
  final TodoRepository _todoRepository;

  AddTodoUsecase(this._todoRepository);

  Future<Result<TodoFailure, void>> call(Todo todo) async {
    return await _todoRepository.addTodo(todo);
    
  }
}

