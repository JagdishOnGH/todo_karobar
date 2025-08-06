import 'package:floor/floor.dart';
import 'package:todo_clean_karobaar/features/todo/data/model/todo_model.dart';

@dao

abstract class TodoDao {
  @Insert(onConflict: OnConflictStrategy.abort)
  Future<void> addTodo(TodoModel todo);

  @update
  Future<void> updateTodo(TodoModel todo);

  @delete
  Future<void> deleteTodo(TodoModel todo);

  //future of int to return count of todos
  @Query('SELECT COUNT(*) FROM TodoModel')
  Future<int?> getTodoCount();

  @Query('SELECT * FROM TodoModel')
  Future<List<TodoModel>> getAllTodos();


  @Query('SELECT COUNT(*) FROM TodoModel WHERE title = :title')
  Future<int?> getTodoCountByTitle(String title);

  //query to get todos by limit and offset
  @Query('SELECT * FROM TodoModel LIMIT :limit OFFSET :offset')
  Future<List<TodoModel>> getTodosByLimitAndOffset(int limit, int offset);




  @Query('SELECT * FROM TodoModel WHERE id = :id')
  Future<TodoModel?> getTodoById(int id);
}