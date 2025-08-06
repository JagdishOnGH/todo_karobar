import 'package:injectable/injectable.dart';
import 'package:todo_clean_karobaar/features/todo/data/model/todo_model.dart';
import 'package:todo_clean_karobaar/features/todo/domain/entity/todo.dart';
import 'package:todo_clean_karobaar/features/todo/domain/failure/todo_exceptions.dart';
import 'package:todo_clean_karobaar/features/todo/domain/failure/todo_failure.dart';
import 'package:todo_clean_karobaar/features/todo/domain/repository/todo_repository.dart';

import '../../../../core/domain/result.dart';

import '../datasource/todo_datasource.dart';

@LazySingleton(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource _todoDataSource;

  TodoRepositoryImpl(this._todoDataSource);

  @override
  Future<Result<TodoFailure, void>> addTodo(Todo todo) async {
    try {
      await _todoDataSource.addTodo(TodoModel.fromTodo(todo));
      return Success(null);
    } on DuplicateTitleException catch (e){
      return Failure(DuplicateTitleFailure());
    } on AppDatabaseException catch (e){
      return Failure(DatabaseFailure());
    } catch (e){
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<TodoFailure, void>> deleteTodo(Todo todo) async {
    try {
      await _todoDataSource.deleteTodo(TodoModel.fromTodo(todo));
      return Success(null);
    } on AppDatabaseException catch (_) {
      return Failure(DatabaseFailure());
    } catch (_) {
      return Failure(UnknownFailure());
    }
   
  }

  @override
  Future<Result<TodoFailure, List<Todo>>> getTodos({int limit = 50, int offset = 0}) async   {
    try {
      final todos = await _todoDataSource.getTodos(limit: limit, offset: offset);
      return Success(todos);
    } on AppDatabaseException catch (_) {
      return Failure(DatabaseFailure());
    } catch (_) {
      return Failure(UnknownFailure());
    }
   
  }

  @override
  Future<Result<TodoFailure, void>> updateTodo(Todo todo) async {
    try {
      await _todoDataSource.updateTodo(TodoModel.fromTodo(todo));
      return Success(null);
    } on AppDatabaseException catch (_) {
      return Failure(DatabaseFailure());
    } catch (_) {
      return Failure(UnknownFailure());
    }
   
  }

 
}