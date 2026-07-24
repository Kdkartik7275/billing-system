/// Base contract every usecase implements: a single [call] entrypoint
/// taking [Params] and returning a [Future] of [Type]. Keeps usecases
/// callable like functions (`await addProductUseCase(params)`) and
/// interchangeable for testing/mocking.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Marker for usecases that take no parameters.
class NoParams {
  const NoParams();
}
