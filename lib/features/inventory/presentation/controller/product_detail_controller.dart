import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/get_product_stock_batches_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/get_product_stock_movements_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final GetProductStockBatchesUsecase getProductStockBatchesUsecase;
  final GetProductStockMovementsUsecase getProductStockMovementsUsecase;
  final String productId;

  ProductDetailController({
    required this.getProductStockBatchesUsecase,
    required this.getProductStockMovementsUsecase,
    required this.productId,
  });

  RxList<StockBatchEntity> stockBatches = <StockBatchEntity>[].obs;
  RxList<StockMovementEntity> stockMovements = <StockMovementEntity>[].obs;
  @override
  void onInit() {
    super.onInit();
    Future.wait([
      fetchProductStockBatches(productId),
      fetchProductStockMovements(productId),
    ]);
  }

  Future<void> fetchProductStockBatches(String productId) async {
    final result = await getProductStockBatchesUsecase.call(productId);
    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message);
      },
      (batches) {
        // Handle the fetched stock batches
        debugPrint(
          'Fetched ${batches.length} stock batches for product $productId',
        );
        stockBatches.value = batches;
      },
    );
  }

  Future<void> fetchProductStockMovements(String productId) async {
    final result = await getProductStockMovementsUsecase.call(productId);
    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message);
      },
      (movements) {
        // Handle the fetched stock movements
        debugPrint(
          'Fetched ${movements.length} stock movements for product $productId',
        );
        stockMovements.value = movements;
      },
    );
  }

  void deleteProduct() {
    Get.back();
  }
}
