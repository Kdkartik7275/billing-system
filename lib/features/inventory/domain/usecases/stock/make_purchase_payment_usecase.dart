import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_payment_entity.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class MakePurchasePaymentUseCase
    implements
        UseCaseWithParams<
          (PurchaseEntity, PurchasePaymentEntity),
          MakePurchasePaymentParams
        > {
  final StockRepository repository;

  MakePurchasePaymentUseCase({required this.repository});

  @override
  ResultFuture<(PurchaseEntity, PurchasePaymentEntity)> call(
    MakePurchasePaymentParams params,
  ) async {
    return await repository.makePurchasePayment(
      purchaseId: params.purchaseId,
      amount: params.amountPaid,
      paymentMethod: params.paymentMethod,
      notes: params.notes,
    );
  }
}

class MakePurchasePaymentParams {
  final String purchaseId;
  final double amountPaid;
  final String paymentMethod;
  final String? notes;

  MakePurchasePaymentParams({
    required this.purchaseId,
    required this.amountPaid,
    required this.paymentMethod,
    this.notes,
  });
}
