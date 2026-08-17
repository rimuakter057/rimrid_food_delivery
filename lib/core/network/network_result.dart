abstract class NetworkResult<T> {
  const NetworkResult();

  factory NetworkResult.success(T data) = Success<T>;
  factory NetworkResult.failure(String error) = Failure<T>;
}

class Success<T> extends NetworkResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends NetworkResult<T> {
  final String error;
  const Failure(this.error);
}
