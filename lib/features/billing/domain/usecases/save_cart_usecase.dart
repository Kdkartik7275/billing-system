import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/billing_cart_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/billing_cart_repository.dart';

class SaveCartUsecase implements UseCaseWithParams<void, BillingCartEntity> {
  final BillingCartRepository repository;

  SaveCartUsecase({required this.repository});

  @override
  ResultFuture<void> call(BillingCartEntity params) async {
    return await repository.saveCart(params);
  }
}
