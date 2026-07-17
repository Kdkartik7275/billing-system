import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';
import 'package:billing_system/features/user/domain/repository/user_repository.dart';

class GetUserByIdUseCase implements UseCaseWithParams<UserEntity, String> {
  final UserRepository repository;

  GetUserByIdUseCase({required this.repository});

  @override
  ResultFuture<UserEntity> call(String userId) async {
    return await repository.getUserById(userId);
  }
}
