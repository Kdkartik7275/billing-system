import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';

class ChangePasswordUsecase
    implements UseCaseWithParams<void, ChangePasswordParams> {
  final AuthenticationRepository repository;

  ChangePasswordUsecase({required this.repository});
  @override
  ResultFuture<void> call(ChangePasswordParams params) async {
    return await repository.changeUserPassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams({required this.oldPassword, required this.newPassword});
}
