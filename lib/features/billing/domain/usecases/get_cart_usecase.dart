import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/entities/billing_cart_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/billing_cart_repository.dart';

class GetCartUsecase implements UseCaseWithoutParams<BillingCartEntity?> {
  final BillingCartRepository repository;

  GetCartUsecase({required this.repository});

  @override
  ResultFuture<BillingCartEntity?> call() async {
    return await repository.getCart();
  }
}
