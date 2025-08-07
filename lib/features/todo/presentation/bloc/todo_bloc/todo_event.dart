part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

/// Dispatched to fetch the initial list of todos or to refresh it.
class TodosFetched extends TodoEvent {
  const TodosFetched();
}

/// Dispatched when a new todo is to be added.
class TodoAdded extends TodoEvent {
  final Todo todo;

  const TodoAdded(this.todo);

  @override
  List<Object> get props => [todo];
}

/// Dispatched when an existing todo's details (title, description, etc.) are to be updated.
class TodoUpdated extends TodoEvent {
  final Todo todo;

  const TodoUpdated(this.todo);

  @override
  List<Object> get props => [todo];
}

/// Dispatched when a todo is to be deleted from the database.
class TodoDeleted extends TodoEvent {
  final Todo todo;

  const TodoDeleted(this.todo);

  @override
  List<Object> get props => [todo];
}

/// Dispatched when a todo's completed status is toggled.
class TodoToggled extends TodoEvent {
  final Todo todo;

  const TodoToggled(this.todo);

  @override
  List<Object> get props => [todo];
}

class TodoSearchQueryChanged extends TodoEvent {
  final String query;

  const TodoSearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class TodoFilterChanged extends TodoEvent {
  final TodoFilter filter;

  const TodoFilterChanged(this.filter);

  @override
  List<Object> get props => [filter];
}

class TodoTransientFailureConsumed extends TodoEvent {
  const TodoTransientFailureConsumed();
}

class MoreTodosFetched extends TodoEvent {
  const MoreTodosFetched();
}
