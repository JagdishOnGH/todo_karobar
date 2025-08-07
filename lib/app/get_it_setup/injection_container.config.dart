// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/todo/data/dao/todo_dao.dart' as _i512;
import '../../features/todo/data/datasource/floor_todo_datasource_impl.dart'
    as _i545;
import '../../features/todo/data/datasource/todo_datasource.dart' as _i1011;
import '../../features/todo/data/repository/todo_repository_impl.dart' as _i262;
import '../../features/todo/domain/repository/todo_repository.dart' as _i673;
import '../../features/todo/domain/usecase/add_todo_usecase.dart' as _i41;
import '../../features/todo/domain/usecase/delete_todo_usecase.dart' as _i478;
import '../../features/todo/domain/usecase/get_todos_usecase.dart' as _i1020;
import '../../features/todo/domain/usecase/toggle_todo_usecase.dart' as _i540;
import '../../features/todo/domain/usecase/update_todo_usecase.dart' as _i920;
import '../../features/todo/presentation/bloc/todo_bloc/todo_bloc.dart' as _i25;
import '../floor_setup/floor_setup.dart' as _i861;
import 'app_modules.dart' as _i110;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final databaseModule = _$DatabaseModule();
    final usecaseModule = _$UsecaseModule(this);
    await gh.factoryAsync<_i861.AppDatabase>(
      () => databaseModule.db,
      preResolve: true,
    );
    gh.lazySingleton<_i512.TodoDao>(
        () => databaseModule.getTodoDao(gh<_i861.AppDatabase>()));
    gh.lazySingleton<_i1011.TodoDataSource>(
        () => _i545.FloorTodoDataSourceImpl(gh<_i512.TodoDao>()));
    gh.lazySingleton<_i673.TodoRepository>(
        () => _i262.TodoRepositoryImpl(gh<_i1011.TodoDataSource>()));
    gh.lazySingleton<_i41.AddTodoUsecase>(() => usecaseModule.addTodoUsecase);
    gh.lazySingleton<_i478.DeleteTodoUsecase>(
        () => usecaseModule.deleteTodoUsecase);
    gh.lazySingleton<_i920.UpdateTodoUsecase>(
        () => usecaseModule.updateTodoUsecase);
    gh.lazySingleton<_i540.ToggleTodoUsecase>(
        () => usecaseModule.toggleTodoUsecase);
    gh.lazySingleton<_i1020.GetTodosUsecase>(
        () => usecaseModule.getTodosUsecase);
    gh.factory<_i25.TodoBloc>(() => _i25.TodoBloc(
          gh<_i1020.GetTodosUsecase>(),
          gh<_i41.AddTodoUsecase>(),
          gh<_i920.UpdateTodoUsecase>(),
          gh<_i478.DeleteTodoUsecase>(),
          gh<_i540.ToggleTodoUsecase>(),
        ));
    return this;
  }
}

class _$DatabaseModule extends _i110.DatabaseModule {}

class _$UsecaseModule extends _i110.UsecaseModule {
  _$UsecaseModule(this._getIt);

  final _i174.GetIt _getIt;

  @override
  _i41.AddTodoUsecase get addTodoUsecase =>
      _i41.AddTodoUsecase(_getIt<_i673.TodoRepository>());

  @override
  _i478.DeleteTodoUsecase get deleteTodoUsecase =>
      _i478.DeleteTodoUsecase(_getIt<_i673.TodoRepository>());

  @override
  _i920.UpdateTodoUsecase get updateTodoUsecase =>
      _i920.UpdateTodoUsecase(_getIt<_i673.TodoRepository>());

  @override
  _i540.ToggleTodoUsecase get toggleTodoUsecase =>
      _i540.ToggleTodoUsecase(_getIt<_i673.TodoRepository>());

  @override
  _i1020.GetTodosUsecase get getTodosUsecase =>
      _i1020.GetTodosUsecase(_getIt<_i673.TodoRepository>());
}
