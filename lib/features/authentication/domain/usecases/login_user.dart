import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUser implements UseCaseWithParams<User?, LoginParams> {
  final AuthenticationRepository repository;

  LoginUser({required this.repository});

  @override
  ResultFuture<User?> call(LoginParams params) async {
    return await repository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
