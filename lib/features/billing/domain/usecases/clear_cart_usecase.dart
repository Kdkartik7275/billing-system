import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/billing/domain/repositories/billing_cart_repository.dart';

class ClearCartUsecase implements UseCaseWithoutParams<void> {
  final BillingCartRepository repository;

  ClearCartUsecase({required this.repository});

  @override
  ResultFuture<void> call() async {
    return await repository.clearCart();
  }
}
