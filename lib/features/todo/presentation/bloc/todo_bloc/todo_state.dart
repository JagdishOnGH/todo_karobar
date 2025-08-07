part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoadInProgress extends TodoState {}

// ... (imports and other states are the same) ...

class TodoLoadSuccess extends TodoState {
  /// The master list of all fetched todos. Should not be modified by filtering.
  final List<Todo> allTodos;

  /// The list of todos to be displayed, which can be filtered.
  final List<Todo> filteredTodos;

  /// The active search query. An empty string means no search is active.
  final String searchQuery; // <-- ADD THIS

  final TodoFailure? transientFailure;

  const TodoLoadSuccess({
    this.allTodos = const [],
    this.filteredTodos = const [],
    this.searchQuery = '', // <-- INITIALIZE THIS
    this.transientFailure,
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
    List<Todo>? filteredTodos,
    String? searchQuery, // <-- ADD TO COPYWITH
    bool clearTransientFailure = false,
    TodoFailure? transientFailure,
  }) {
    return TodoLoadSuccess(
      allTodos: allTodos ?? this.allTodos,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      searchQuery: searchQuery ?? this.searchQuery, // <-- HANDLE THIS
      transientFailure: clearTransientFailure
          ? null
          : transientFailure ?? this.transientFailure,
    );
  }
}

// ... (rest of the file is the same) ...

class TodoLoadFailure extends TodoState {
  final TodoFailure failure;

  const TodoLoadFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
