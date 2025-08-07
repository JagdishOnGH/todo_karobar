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
    return Scaffold(
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
          }
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: const Text('My Tasks'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: Implement filter functionality
                  },
                ),
              ],
              floating: true,
              snap: true,
            ),
            SliverPersistentHeader(
              delegate: SearchBarDelegate(),
              pinned: true,
            ),
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoadInProgress || state is TodoInitial) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TodoLoadFailure) {
                  return SliverFillRemaining(
                    child: AppErrorWidget(
                        message: state.failure.value.toString(),
                        onRetry: () =>
                            context.read<TodoBloc>().add(const TodosFetched())),
                  );
                }
                if (state is TodoLoadSuccess) {
                  final todos = state.filteredTodos;
                  if (todos.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: state.searchQuery.isNotEmpty
                            ? NoResultsWidget(query: state.searchQuery)
                            : const EmptyStateWidget(),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final todo = todos[index];
                          return TodoTile(todo: todo);
                        },
                        childCount: todos.length,
                      ),
                    ),
                  );
                }
                return const SliverFillRemaining(
                  child: Center(child: Text('Something went wrong!')),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
