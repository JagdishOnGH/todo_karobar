import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc/todo_bloc.dart';
import '../widgets/add_edit_bottom_sheet.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/no_search_result.dart';
import '../widgets/search_bar_delegate.dart';
import '../widgets/todo_tile.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

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
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
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
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoTile(todo: todo);
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
