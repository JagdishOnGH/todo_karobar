import 'package:flutter/material.dart';

class NoResultsWidget extends StatelessWidget {
  final String query;
  const NoResultsWidget({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.search_off_rounded,
          size: 96,
          color: colorScheme.primary.withAlpha(80),
        ),
        const SizedBox(height: 16.0),
        Text(
          'No Results Found',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Your search for "$query" did not match any tasks.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
