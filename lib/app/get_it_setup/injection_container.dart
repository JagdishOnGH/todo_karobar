import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_clean_karobaar/app/get_it_setup/injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() => getIt.init();
