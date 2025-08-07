import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc/todo_bloc.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SearchBar(
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          autoFocus: false,
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {},
          onChanged: (text) {
            context.read<TodoBloc>().add(TodoSearchQueryChanged(text));
          },
          leading: const Icon(Icons.search),
          hintText: 'Search tasks by title...',
        ));
  }

  @override
  double get maxExtent => 72.0;

  @override
  double get minExtent => 72.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
