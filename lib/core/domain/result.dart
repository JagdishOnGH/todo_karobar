
sealed class Result<L, R> {
  
  T fold<T>(T Function(L failure) onFailure, T Function(R success) onSuccess);

  
  bool get isSuccess => this is Success<L, R>;

 
  bool get isFailure => this is Failure<L, R>;
}


class Success<L, R> extends Result<L, R> {
  final R value;

  Success(this.value);

  @override
  T fold<T>(T Function(L failure) onFailure, T Function(R success) onSuccess) {
   
    return onSuccess(value);
  }
}


class Failure<L, R> extends Result<L, R> {
  final L value;

  Failure(this.value);

  @override
  T fold<T>(T Function(L failure) onFailure, T Function(R success) onSuccess) {
   
    return onFailure(value);
  }
}