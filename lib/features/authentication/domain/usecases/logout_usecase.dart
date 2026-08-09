import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';

class LogoutUsecase implements UseCaseWithoutParams<void> {
  final AuthenticationRepository repository;

  LogoutUsecase({required this.repository});

  @override
  ResultFuture<void> call() async {
    return await repository.logout();
  }
}
