//delete todo usecase


import 'package:todo_clean_karobaar/features/todo/domain/entity/todo.dart';

import '../../../../core/domain/result.dart';
import '../failure/todo_failure.dart';
import '../repository/todo_repository.dart';

class DeleteTodoUsecase {
  final TodoRepository _todoRepository;

  DeleteTodoUsecase(this._todoRepository);

  Future<Result<TodoFailure, void>> call(Todo todo) async {
    return await _todoRepository.deleteTodo(todo);
  }


  
}
