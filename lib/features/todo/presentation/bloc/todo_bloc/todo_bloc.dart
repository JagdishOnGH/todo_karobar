import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entity/todo.dart';
import '../../../domain/failure/todo_failure.dart';
import '../../../domain/usecase/add_todo_usecase.dart';
import '../../../domain/usecase/delete_todo_usecase.dart';
import '../../../domain/usecase/get_todos_usecase.dart';
import '../../../domain/usecase/toggle_todo_usecase.dart';
import '../../../domain/usecase/update_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

@Injectable(order: 9)
class TodoBloc extends Bloc<TodoEvent, TodoState> {
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
    on<TodoAdded>(_onTodoAdded);
    on<TodoUpdated>(_onTodoUpdated);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodoToggled>(_onTodoToggled);
    on<TodoSearchQueryChanged>(_onTodoSearchQueryChanged);
  }

  // ... (imports) ...

// ...

  Future<void> _onTodosFetched(
    TodosFetched event,
    Emitter<TodoState> emit,
  ) async {
    // When fetching fresh, clear any previous search query
    final currentSearchQuery =
        state is TodoLoadSuccess ? (state as TodoLoadSuccess).searchQuery : '';

    emit(TodoLoadInProgress());
    final result = await _getTodosUsecase();
    result.fold(
      (failure) => emit(TodoLoadFailure(failure)),
      (todos) {
        // If there was a search query before, re-apply it to the new list
        if (currentSearchQuery.isNotEmpty) {
          final filtered = todos.where((todo) {
            return todo.title
                .toLowerCase()
                .contains(currentSearchQuery.toLowerCase());
          }).toList();
          emit(TodoLoadSuccess(
              allTodos: todos,
              filteredTodos: filtered,
              searchQuery: currentSearchQuery));
        } else {
          emit(TodoLoadSuccess(
              allTodos: todos, filteredTodos: todos, searchQuery: ''));
        }
      },
    );
  }

  void _onTodoSearchQueryChanged(
    TodoSearchQueryChanged event,
    Emitter<TodoState> emit,
  ) {
    final currentState = state;
    if (currentState is TodoLoadSuccess) {
      final query = event.query.toLowerCase();
      final filtered = currentState.allTodos.where((todo) {
        return todo.title.toLowerCase().contains(query);
      }).toList();

      // Pass the query down to the state
      emit(currentState.copyWith(
        filteredTodos: filtered,
        searchQuery: event.query, // <-- UPDATE THE QUERY HERE
      ));
    }
  }

// ... (rest of the bloc is the same) ...

  Future<void> _onTodoAdded(
    TodoAdded event,
    Emitter<TodoState> emit,
  ) async {
    final result = await _addTodoUsecase(event.todo);
    final currentState = state;

    if (currentState is TodoLoadSuccess) {
      result.fold(
        (failure) => emit(currentState.copyWith(transientFailure: failure)),
        (_) => add(const TodosFetched()), // On success, refresh the list
      );
    }
  }

  Future<void> _onTodoUpdated(
    TodoUpdated event,
    Emitter<TodoState> emit,
  ) async {
    final result = await _updateTodoUsecase(event.todo);
    final currentState = state;

    if (currentState is TodoLoadSuccess) {
      result.fold(
        (failure) => emit(currentState.copyWith(transientFailure: failure)),
        (_) => add(const TodosFetched()),
      );
    }
  }

  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoState> emit,
  ) async {
    final result = await _deleteTodoUsecase(event.todo);
    final currentState = state;

    if (currentState is TodoLoadSuccess) {
      result.fold(
        (failure) => emit(currentState.copyWith(transientFailure: failure)),
        (_) => add(const TodosFetched()),
      );
    }
  }

  Future<void> _onTodoToggled(
    TodoToggled event,
    Emitter<TodoState> emit,
  ) async {
    final result = await _toggleTodoUsecase(event.todo);
    final currentState = state;

    if (currentState is TodoLoadSuccess) {
      result.fold(
        (failure) => emit(currentState.copyWith(transientFailure: failure)),
        (_) => add(const TodosFetched()),
      );
    }
  }
}
