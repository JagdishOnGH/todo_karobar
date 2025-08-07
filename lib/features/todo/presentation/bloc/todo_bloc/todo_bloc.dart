import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/domain/result.dart';
import '../../../domain/entity/todo.dart';
import '../../../domain/failure/todo_failure.dart';
import '../../../domain/usecase/add_todo_usecase.dart';
import '../../../domain/usecase/delete_todo_usecase.dart';
import '../../../domain/usecase/get_todos_usecase.dart';
import '../../../domain/usecase/toggle_todo_usecase.dart';
import '../../../domain/usecase/update_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  static const int _todosPerPage = 10;
  final GetTodosUsecase _getTodosUsecase;
  final AddTodoUsecase _addTodoUsecase;
  final UpdateTodoUsecase _updateTodoUsecase;
  final DeleteTodoUsecase _deleteTodoUsecase;
  final ToggleTodoUsecase _toggleTodoUsecase;

  TodoBloc(
    this._getTodosUsecase,
    this._addTodoUsecase,
    this._updateTodoUsecase,
    this._deleteTodoUsecase,
    this._toggleTodoUsecase,
  ) : super(TodoInitial()) {
    on<TodosFetched>(_onTodosFetched);
    on<TodoSearchQueryChanged>(_onTodoSearchQueryChanged);
    on<TodoFilterChanged>(_onTodoFilterChanged);
    on<TodoAdded>(_onTodoAdded);
    on<TodoUpdated>(_onTodoUpdated);
    on<MoreTodosFetched>(_onMoreTodosFetched);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodoToggled>(_onTodoToggled);
    on<TodoTransientFailureConsumed>(_onTodoTransientFailureConsumed);
  }

  // This helper function is the single source of truth for filtering.
  // It takes the master list and applies the necessary filters.
  List<Todo> _applyFilters(
      List<Todo> todos, TodoFilter filter, String searchQuery) {
    // 1. Apply tab filter
    final List<Todo> tabFiltered;
    switch (filter) {
      case TodoFilter.pending:
        tabFiltered = todos.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.completed:
        tabFiltered = todos.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.all:
        tabFiltered = todos;
        break;
    }

    // 2. Apply search query on the result of the tab filter
    if (searchQuery.isEmpty) {
      return tabFiltered;
    } else {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return tabFiltered.where((todo) {
        return todo.title.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }
  }

  void _onTodoFilterChanged(
    TodoFilterChanged event,
    Emitter<TodoState> emit,
  ) {
    final currentState = state;
    if (currentState is TodoLoadSuccess) {
      // Re-calculate the filtered list using the NEW filter
      final updatedFilteredTodos = _applyFilters(
          currentState.allTodos, // Source of truth is always allTodos
          event.filter, // Use the new filter from the event
          currentState.searchQuery // Keep the existing search query
          );

      // Emit a new state with the new filter and the new list
      emit(currentState.copyWith(
        filter: event.filter,
        filteredTodos: updatedFilteredTodos,
      ));
    }
  }

  void _onTodoSearchQueryChanged(
    TodoSearchQueryChanged event,
    Emitter<TodoState> emit,
  ) {
    final currentState = state;
    if (currentState is TodoLoadSuccess) {
      // Re-calculate the filtered list using the NEW search query
      final updatedFilteredTodos = _applyFilters(
          currentState.allTodos, // Source of truth is always allTodos
          currentState.filter, // Keep the existing tab filter
          event.query // Use the new query from the event
          );

      // Emit a new state with the new query and the new list
      emit(currentState.copyWith(
        searchQuery: event.query,
        filteredTodos: updatedFilteredTodos,
      ));
    }
  }

  Future<void> _onTodosFetched(
    TodosFetched event,
    Emitter<TodoState> emit,
  ) async {
    final currentState = state;
    // Preserve filters on refresh
    final currentFilter =
        currentState is TodoLoadSuccess ? currentState.filter : TodoFilter.all;
    final currentQuery =
        currentState is TodoLoadSuccess ? currentState.searchQuery : '';

    emit(TodoLoadInProgress());
    final result = await _getTodosUsecase(limit: _todosPerPage);

    result.fold(
      (failure) => emit(TodoLoadFailure(failure)),
      (todos) {
        final hasReachedMax = todos.length < _todosPerPage;
        // After fetching new data, immediately apply the preserved filters
        final filtered = _applyFilters(todos, currentFilter, currentQuery);

        emit(TodoLoadSuccess(
          allTodos: todos,
          filteredTodos: filtered,
          hasReachedMax: hasReachedMax,
          filter: currentFilter,
          searchQuery: currentQuery,
        ));
      },
    );
  }

  Future<void> _onMoreTodosFetched(
    MoreTodosFetched event,
    Emitter<TodoState> emit,
  ) async {
    final currentState = state;

    if (currentState is TodoLoadSuccess) {
      // If we are not in a success state, we can't fetch more.
    }
    // We only fetch more if we are in a success state and haven't reached the max.
    if (currentState is TodoLoadSuccess && !currentState.hasReachedMax) {
      final currentOffset = currentState.allTodos.length;
      final result = await _getTodosUsecase(
        limit: _todosPerPage,
        offset: currentOffset,
      );

      result.fold(
        (failure) {
          // On failure, we can choose to emit a transient failure
          emit(currentState.copyWith(transientFailure: DatabaseFailure()));
        },
        (newTodos) {
          // If the fetch returns fewer items than the page size, we've reached the end.
          final hasReachedMax = newTodos.length < _todosPerPage;
          final updatedAllTodos = List.of(currentState.allTodos)
            ..addAll(newTodos);

          // Re-apply the current filters to the newly combined master list
          final filtered = _applyFilters(
            updatedAllTodos,
            currentState.filter,
            currentState.searchQuery,
          );

          emit(currentState.copyWith(
            allTodos: updatedAllTodos,
            filteredTodos: filtered,
            hasReachedMax: hasReachedMax,
          ));
        },
      );
    }
  }

  // All modification events should trigger a full refresh to ensure data consistency.
  // The _onTodosFetched handler will correctly re-apply the current filters.
  Future<void> _onTodoAdded(TodoAdded event, Emitter<TodoState> emit) async {
    final result = await _addTodoUsecase(event.todo);
    _handleModificationResult(result, emit);
  }

  Future<void> _onTodoUpdated(
      TodoUpdated event, Emitter<TodoState> emit) async {
    final result = await _updateTodoUsecase(event.todo);
    _handleModificationResult(result, emit);
  }

  Future<void> _onTodoDeleted(
      TodoDeleted event, Emitter<TodoState> emit) async {
    final result = await _deleteTodoUsecase(event.todo);
    _handleModificationResult(result, emit);
  }

  Future<void> _onTodoToggled(
      TodoToggled event, Emitter<TodoState> emit) async {
    final result = await _toggleTodoUsecase(event.todo);
    _handleModificationResult(result, emit);
  }

  void _handleModificationResult(
      Result<TodoFailure, void> result, Emitter<TodoState> emit) {
    final currentState = state;
    if (currentState is TodoLoadSuccess) {
      result.fold(
        (failure) => emit(currentState.copyWith(transientFailure: failure)),
        (_) => add(const TodosFetched()), // On success, refresh the whole list
      );
    }
  }

  void _onTodoTransientFailureConsumed(
    TodoTransientFailureConsumed event,
    Emitter<TodoState> emit,
  ) {
    final currentState = state;
    if (currentState is TodoLoadSuccess) {
      // Emit a copy of the current state, but explicitly clear the failure.
      emit(currentState.copyWith(clearTransientFailure: true));
    }
  }
}
