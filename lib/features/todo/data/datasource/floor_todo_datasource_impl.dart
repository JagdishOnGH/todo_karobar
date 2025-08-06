import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_clean_karobaar/features/todo/data/datasource/todo_datasource.dart';
import 'package:todo_clean_karobaar/features/todo/data/model/todo_model.dart';
import 'package:todo_clean_karobaar/features/todo/data/dao/todo_dao.dart';
import 'package:todo_clean_karobaar/features/todo/domain/entity/todo.dart';
import 'package:todo_clean_karobaar/features/todo/domain/failure/todo_exceptions.dart';

@LazySingleton(as: TodoDataSource)
class FloorTodoDataSourceImpl implements TodoDataSource {
  final TodoDao _todoDao;

  FloorTodoDataSourceImpl(this._todoDao);

  @override
  Future<void> addTodo(TodoModel todo) async {
    //just call addTodo from dao
    try {
      await _todoDao.addTodo(todo);
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw DuplicateTitleException();
      }
      throw AppDatabaseException(
        "Failed to add todo ${todo.title} with code ${e.getResultCode()}",
      );
    }
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {
    try {
      await _todoDao.deleteTodo(todo);
    } on DatabaseException catch (e) {
      throw AppDatabaseException(
        "Failed to delete todo ${todo.title} with code ${e.getResultCode()}",
      );
    }
  }

  @override
  Future<List<Todo>> getTodos({int limit = 50, int offset = 0}) async {
    try {
      final todos = await _todoDao.getTodosByLimitAndOffset(limit, offset);
      return todos.map((todo) => todo.toTodo()).toList();
    } on DatabaseException catch (e) {
      throw AppDatabaseException(
        "Failed to get todos with code ${e.getResultCode()}",
      );
    }
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    try {
      await _todoDao.updateTodo(todo);
    } on DatabaseException catch (e) {
      throw AppDatabaseException(
        "Failed to update todo ${todo.title} with code ${e.getResultCode()}",
      );
    }
  }
}
