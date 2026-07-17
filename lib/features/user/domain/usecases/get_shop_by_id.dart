import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:billing_system/features/user/domain/repository/user_repository.dart';

class GetShopByIdUseCase implements UseCaseWithParams<ShopEntity, String> {
  final UserRepository repository;

  GetShopByIdUseCase({required this.repository});

  @override
  ResultFuture<ShopEntity> call(String shopId) async {
    return await repository.getShopById(shopId);
  }
}
