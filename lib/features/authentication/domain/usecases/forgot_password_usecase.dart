import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';

class ForgotPasswordUsecase implements UseCaseWithParams<void, String> {
  final AuthenticationRepository repository;

  ForgotPasswordUsecase({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.forgotPassword(params);
  }
}
