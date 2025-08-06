
import '../../../../core/domain/result.dart';
import '../entity/todo.dart';
import '../failure/todo_failure.dart';
import '../repository/todo_repository.dart';

class GetTodosUsecase {
  final TodoRepository _todoRepository;

  GetTodosUsecase(this._todoRepository);

  Future<Result<TodoFailure, List<Todo>>> call({int limit = 50, int offset = 0}) async {
    return await _todoRepository.getTodos(limit: limit, offset: offset);
  }
  

}
