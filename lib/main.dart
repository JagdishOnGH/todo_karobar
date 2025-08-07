import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_karobaar/app/observer_setup/bloc_observer.dart';

import 'app/get_it_setup/injection_container.dart';
import 'features/todo/presentation/bloc/todo_bloc/todo_bloc.dart';
import 'features/todo/presentation/pages/todo_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TodoBloc>()..add(TodosFetched()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue.shade700,
          brightness: Brightness.light,
        ),
        home: const TodoListPage(),
      ),
    );
  }
}
