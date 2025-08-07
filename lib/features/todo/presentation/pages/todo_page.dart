import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc/todo_bloc.dart';
import '../widgets/add_edit_bottom_sheet.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/no_search_result.dart';
import '../widgets/search_bar_delegate.dart';
import '../widgets/todo_tile.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      // Dispatch the event to fetch more todos
      context.read<TodoBloc>().add(const MoreTodosFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Add a little buffer (e.g., 50 pixels) to trigger loading just before the end
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoLoadSuccess && state.transientFailure != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.transientFailure!.value.toString()),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              context
                  .read<TodoBloc>()
                  .add(const TodoTransientFailureConsumed());
            }
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: const Text('My Tasks'),
                  bottom: TabBar(
                    onTap: (index) {
                      final filter = TodoFilter.values[index];
                      context.read<TodoBloc>().add(TodoFilterChanged(filter));
                    },
                    tabs: [
                      _buildTab('All', TodoFilter.all),
                      _buildTab('Pending', TodoFilter.pending),
                      _buildTab('Completed', TodoFilter.completed),
                    ],
                  ),
                  floating: true,
                  snap: true,
                ),
                SliverPersistentHeader(
                  delegate: SearchBarDelegate(),
                  pinned: true,
                ),
              ];
            },
            body: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoadInProgress || state is TodoInitial) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is TodoLoadFailure) {
                  return AppErrorWidget(
                      message: state.failure.value.toString(),
                      onRetry: () =>
                          context.read<TodoBloc>().add(const TodosFetched()));
                }
                if (state is TodoLoadSuccess) {
                  final todos = state.filteredTodos;
                  if (todos.isEmpty) {
                    return Center(
                      child: state.searchQuery.isNotEmpty
                          ? NoResultsWidget(query: state.searchQuery)
                          : const EmptyStateWidget(),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    itemCount:
                        state.hasReachedMax ? todos.length : todos.length + 1,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index >= todos.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: RepaintBoundary(
                                child: CircularProgressIndicator()),
                          ),
                        );
                      }
                      final todo = todos[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: TodoTile(
                          key: ValueKey(todo.id),
                          todo: todo,
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('Something went wrong!'));
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAddEditSheet(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTab(String title, TodoFilter filter) {
    return BlocBuilder<TodoBloc, TodoState>(
      // Use buildWhen to prevent unnecessary rebuilds of the tabs
      buildWhen: (previous, current) {
        if (previous is! TodoLoadSuccess || current is! TodoLoadSuccess) {
          return true;
        }
        // Rebuild only if the counts change
        return previous.allTodos.length != current.allTodos.length ||
            previous.completedTodos.length != current.completedTodos.length;
      },
      builder: (context, state) {
        if (state is TodoLoadSuccess) {
          final int count;
          switch (filter) {
            case TodoFilter.all:
              count = state.allTodos.length;
              break;
            case TodoFilter.pending:
              count = state.pendingTodos.length;
              break;
            case TodoFilter.completed:
              count = state.completedTodos.length;
              break;
          }
          return Tab(text: '$title ($count)');
        }
        return Tab(text: title); // Fallback
      },
    );
  }
}
