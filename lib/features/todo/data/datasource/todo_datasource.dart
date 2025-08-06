 import 'package:todo_clean_karobaar/features/todo/domain/entity/todo.dart';

import '../model/todo_model.dart';

abstract class TodoDataSource {
  
  Future<List<Todo>> getTodos({int limit = 50, int offset = 0});
   
  Future<void> addTodo(TodoModel todo);
  
  //update todo
  Future<void> updateTodo(TodoModel todo);
  
  //delete todo
  Future<void> deleteTodo(TodoModel todo);
}
