import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class SellStockParams {
  final String productId;
  final String warehouseId;
  final int quantity;
  final double price;
  final DateTime saleDate;
  final double? discount;
  final double tax;
  final String paymentMethod;
  final String? reason;
  final String? referenceId;
  final String? notes;

  const SellStockParams({
    required this.productId,
    required this.warehouseId,
    required this.quantity,
    required this.price,
    required this.saleDate,
    this.discount,
    required this.tax,
    required this.paymentMethod,
    this.reason,
    this.referenceId,
    this.notes,
  });
}

class SellStockUsecase implements UseCaseWithParams<void, SellStockParams> {
  final StockRepository repository;

  SellStockUsecase({required this.repository});

  @override
  ResultFuture<void> call(SellStockParams params) async {
    return await repository.sellStock(
      productId: params.productId,
      warehouseId: params.warehouseId,
      quantity: params.quantity,
      price: params.price,
      saleDate: params.saleDate,
      discount: params.discount,
      tax: params.tax,
      paymentMethod: params.paymentMethod,
      reason: params.reason,
      referenceId: params.referenceId,
      notes: params.notes,
    );
  }
}
