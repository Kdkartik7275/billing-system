import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/features/billing/data/data_source/local/billing_cart_local_data_source.dart';
import 'package:billing_system/features/billing/data/models/billing_cart_model.dart';
import 'package:billing_system/features/billing/domain/entities/billing_cart_entity.dart';
import 'package:billing_system/features/billing/domain/repositories/billing_cart_repository.dart';
import 'package:fpdart/fpdart.dart';

class BillingCartRepositoryImpl implements BillingCartRepository {
  final BillingCartLocalDataSource localDataSource;

  BillingCartRepositoryImpl({required this.localDataSource});

  @override
  ResultFuture<BillingCartEntity?> getCart() async {
    try {
      final local = await localDataSource.getCart();

      return right(local?.toEntity());
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> saveCart(BillingCartEntity cart) async {
    try {
      final model = BillingCartModel.fromEntity(cart);

      await localDataSource.saveCart(model);

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> clearCart() async {
    try {
      await localDataSource.clearCart();

      return const Right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
