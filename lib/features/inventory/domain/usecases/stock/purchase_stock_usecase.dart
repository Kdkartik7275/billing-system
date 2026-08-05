import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repositories/stock_repository.dart';

class PurchaseStockUseCase
    implements UseCaseWithParams<void, PurchaseStockParams> {
  final StockRepository repository;

  PurchaseStockUseCase({required this.repository});

  @override
  ResultFuture<void> call(PurchaseStockParams params) async {
    return repository.purchaseStock(
      productId: params.productId,
      warehouseId: params.warehouseId,
      supplierId: params.supplierId,
      quantity: params.quantity,
      price: params.price,
      purchaseDate: params.purchaseDate,
      invoiceNumber: params.invoiceNumber,
      billDate: params.billDate,
      batchNumber: params.batchNumber,
      expiryDate: params.expiryDate,
      discount: params.discount,
      tax: params.tax,
      paymentMethod: params.paymentMethod,
      dueDate: params.dueDate,
      notes: params.notes,
    );
  }
}

class PurchaseStockParams {
  final String productId;
  final String warehouseId;
  final String supplierId;
  final int quantity;
  final double price;
  final DateTime purchaseDate;
  final String invoiceNumber;
  final DateTime billDate;
  final String batchNumber;
  final DateTime? expiryDate;
  final double? discount;
  final double tax;
  final String paymentMethod;
  final DateTime dueDate;
  final String? notes;

  PurchaseStockParams({
    required this.productId,
    required this.warehouseId,
    required this.supplierId,
    required this.quantity,
    required this.price,
    required this.purchaseDate,
    required this.invoiceNumber,
    required this.billDate,
    required this.batchNumber,
    this.expiryDate,
    this.discount,
    required this.tax,
    required this.paymentMethod,
    required this.dueDate,
    this.notes,
  });
}
