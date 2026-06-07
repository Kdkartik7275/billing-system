import 'package:billing_system/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = Future<Either<Failure, void>>;

typedef ResultStream<T> = Stream<Either<Failure, T>>;
