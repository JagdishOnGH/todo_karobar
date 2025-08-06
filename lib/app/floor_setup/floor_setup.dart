import 'dart:async';

import 'package:floor/floor.dart';
import 'package:todo_clean_karobaar/features/todo/data/dao/todo_dao.dart';
import 'package:todo_clean_karobaar/features/todo/data/model/todo_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'floor_setup.g.dart';

@Database(version: 1, entities: [TodoModel])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}



//build runner command for terminal - dart version 
//flutter pub run build_runner build
//
