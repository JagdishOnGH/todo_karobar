

import 'package:injectable/injectable.dart';
import 'package:todo_clean_karobaar/features/todo/data/dao/todo_dao.dart';
import 'package:todo_clean_karobaar/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:todo_clean_karobaar/features/todo/domain/usecase/toggle_todo_usecase.dart';
import 'package:todo_clean_karobaar/features/todo/domain/usecase/update_todo_usecase.dart';

import '../../features/todo/domain/usecase/delete_todo_usecase.dart';
import '../../features/todo/domain/usecase/get_todos_usecase.dart';
import '../floor_setup/floor_setup.dart';

@module
abstract class DatabaseModule {
  @preResolve // ensures async init during init
  Future<AppDatabase> get db => $FloorAppDatabase.databaseBuilder('app_db.db').build();

  @lazySingleton
  TodoDao getTodoDao(AppDatabase database) => database.todoDao;
}


@module 
abstract class UsecaseModule {
  @LazySingleton(order: 2)
  AddTodoUsecase get addTodoUsecase;

  @LazySingleton(order: 3)
  DeleteTodoUsecase get deleteTodoUsecase;

  @LazySingleton(order: 4)
  UpdateTodoUsecase get updateTodoUsecase;

  @LazySingleton(order: 5)
  ToggleTodoUsecase get toggleTodoUsecase;

  @LazySingleton(order: 6)
  GetTodosUsecase get getTodosUsecase;
}
