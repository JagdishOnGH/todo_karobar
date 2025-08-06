// Location: lib/core/error/exceptions.dart

// An abstract base class for our data source exceptions.
abstract class DataSourceException implements Exception {
  final String message;
  DataSourceException(this.message);}

// A specific exception for a duplicate title. This is THROWN by the DataSource.
class DuplicateTitleException extends DataSourceException {
  DuplicateTitleException() : super('UNIQUE constraint failed');
}

// A generic exception for other database issues. This is THROWN by the DataSource.
class AppDatabaseException extends DataSourceException {
  AppDatabaseException(super.message);
}

