part of 'todo_bloc.dart';

enum TodoFilter { all, pending, completed }

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoadInProgress extends TodoState {}

class TodoLoadSuccess extends TodoState {
  /// The master list of all fetched todos. Should not be modified by filtering.
  final List<Todo> allTodos;

  /// The list of todos to be displayed, which can be filtered.
  final List<Todo> filteredTodos;

  /// The active search query. An empty string means no search is active.
  final String searchQuery; // <-- ADD THIS

  final TodoFailure? transientFailure;
  final TodoFilter filter;

  /// Computed property to get pending tasks.
  List<Todo> get pendingTodos =>
      allTodos.where((todo) => !todo.isCompleted).toList();

  /// Computed property to get completed tasks.
  List<Todo> get completedTodos =>
      allTodos.where((todo) => todo.isCompleted).toList();

  const TodoLoadSuccess({
    this.allTodos = const [],
    this.filteredTodos = const [],
    this.searchQuery = '', // <-- INITIALIZE THIS
    this.transientFailure,
    this.filter = TodoFilter.all,
  });

  @override
  List<Object?> get props => [
        allTodos,
        filteredTodos,
        searchQuery,
        transientFailure
      ]; // <-- ADD TO PROPS

  TodoLoadSuccess copyWith({
    List<Todo>? allTodos,
    TodoFilter? filter,
    List<Todo>? filteredTodos,
    String? searchQuery, //
    bool clearTransientFailure = false,
    TodoFailure? transientFailure,
  }) {
    return TodoLoadSuccess(
      allTodos: allTodos ?? this.allTodos,
      filter: filter ?? this.filter,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      searchQuery: searchQuery ?? this.searchQuery,
      transientFailure: clearTransientFailure
          ? null
          : transientFailure ?? this.transientFailure,
    );
  }
}

class TodoLoadFailure extends TodoState {
  final TodoFailure failure;

  const TodoLoadFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
