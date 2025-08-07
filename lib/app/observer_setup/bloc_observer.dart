import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: (DateTime date) {
        final String formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
        return formattedDate;
      },
    ),
  );

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.i('✅ onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.d('↘️ onEvent -- ${bloc.runtimeType}, Event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.t(
      '↔️ onChange -- ${bloc.runtimeType}\n'
      '   - CurrentState: ${change.currentState}\n'
      '   - NextState: ${change.nextState}',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.v(
      '🔄 onTransition -- ${bloc.runtimeType}\n'
      '   - Event: ${transition.event}\n'
      '   - CurrentState: ${transition.currentState}\n'
      '   - NextState: ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.e('❌ onError -- ${bloc.runtimeType}',
        error: error, stackTrace: stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.w('🛑 onClose -- ${bloc.runtimeType}');
  }
}
