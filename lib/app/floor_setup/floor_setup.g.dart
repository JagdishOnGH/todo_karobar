// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_setup.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TodoModel` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `completed` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE UNIQUE INDEX `index_TodoModel_title` ON `TodoModel` (`title`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _todoModelInsertionAdapter = InsertionAdapter(
            database,
            'TodoModel',
            (TodoModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'completed': item.completed ? 1 : 0,
                  'deadline': item.deadline
                }),
        _todoModelUpdateAdapter = UpdateAdapter(
            database,
            'TodoModel',
            ['id'],
            (TodoModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'completed': item.completed ? 1 : 0,
                  'deadline': item.deadline
                }),
        _todoModelDeletionAdapter = DeletionAdapter(
            database,
            'TodoModel',
            ['id'],
            (TodoModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'completed': item.completed ? 1 : 0,
                  'deadline': item.deadline
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TodoModel> _todoModelInsertionAdapter;

  final UpdateAdapter<TodoModel> _todoModelUpdateAdapter;

  final DeletionAdapter<TodoModel> _todoModelDeletionAdapter;

  @override
  Future<int?> getTodoCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM TodoModel',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    return _queryAdapter.queryList('SELECT * FROM TodoModel',
        mapper: (Map<String, Object?> row) => TodoModel(
            id: row['id'] as int,
            title: row['title'] as String,
            description: row['description'] as String,
            completed: (row['completed'] as int) != 0,
            deadline: row['deadline'] as int));
  }

  @override
  Future<int?> getTodoCountByTitle(String title) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM TodoModel WHERE title = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [title]);
  }

  @override
  Future<List<TodoModel>> getTodosByLimitAndOffset(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList('SELECT * FROM TodoModel LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => TodoModel(
            id: row['id'] as int,
            title: row['title'] as String,
            description: row['description'] as String,
            completed: (row['completed'] as int) != 0,
            deadline: row['deadline'] as int),
        arguments: [limit, offset]);
  }

  @override
  Future<TodoModel?> getTodoById(int id) async {
    return _queryAdapter.query('SELECT * FROM TodoModel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TodoModel(
            id: row['id'] as int,
            title: row['title'] as String,
            description: row['description'] as String,
            completed: (row['completed'] as int) != 0,
            deadline: row['deadline'] as int),
        arguments: [id]);
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await _todoModelInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await _todoModelUpdateAdapter.update(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {
    await _todoModelDeletionAdapter.delete(todo);
  }
}
