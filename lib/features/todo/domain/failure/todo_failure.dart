import '../../../../core/domain/result.dart';

//duplicate title failure

sealed class TodoFailure extends Failure {
  TodoFailure(super.value);
  
}
class DuplicateTitleFailure extends TodoFailure {
   DuplicateTitleFailure() : super('Duplicate title occured');
}

class DatabaseFailure extends TodoFailure {
  DatabaseFailure() : super('Database failure occured');
}

class UnknownFailure extends TodoFailure {
  UnknownFailure() : super('Unknown failure occured');
}










