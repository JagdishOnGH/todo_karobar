import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.check_circle_outline,
          size: 96,
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 16.0),
        Text(
          'All tasks completed!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Tap the "+" button to add a new task.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
