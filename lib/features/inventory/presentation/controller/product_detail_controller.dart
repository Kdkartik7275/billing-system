import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
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
  RxBool loadingStockBatches = RxBool(false);
  RxBool loadingStockMovements = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('ProductDetail');

    Future.wait([
      fetchProductStockBatches(productId),
      fetchProductStockMovements(productId),
    ]);
  }

  Future<void> fetchProductStockBatches(String productId) async {
    try {
      loadingStockBatches.value = true;
      final result = await getProductStockBatchesUsecase.call(productId);
      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);

          AnalyticsService.logEvent(
            'product_stock_batches_load_failed',
            parameters: {'product_id': productId, 'error': failure.message},
          );
        },
        (batches) {
          debugPrint(
            'Fetched ${batches.length} stock batches for product $productId',
          );
          stockBatches.value = batches;

          AnalyticsService.logEvent(
            'product_stock_batches_load_success',
            parameters: {
              'product_id': productId,
              'batches_count': batches.length,
            },
          );
        },
      );
    } catch (e) {
      AppSnackbar.error(message: e.toString());

      AnalyticsService.logEvent(
        'product_stock_batches_load_failed',
        parameters: {'product_id': productId, 'error': e.toString()},
      );
    } finally {
      loadingStockBatches.value = false;
    }
  }

  Future<void> fetchProductStockMovements(String productId) async {
    try {
      loadingStockMovements.value = true;
      final result = await getProductStockMovementsUsecase.call(productId);
      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);

          AnalyticsService.logEvent(
            'product_stock_movements_load_failed',
            parameters: {'product_id': productId, 'error': failure.message},
          );
        },
        (movements) {
          debugPrint(
            'Fetched ${movements.length} stock movements for product $productId',
          );
          stockMovements.value = movements;

          AnalyticsService.logEvent(
            'product_stock_movements_load_success',
            parameters: {
              'product_id': productId,
              'movements_count': movements.length,
            },
          );
        },
      );
    } catch (e) {
      AppSnackbar.error(message: e.toString());

      AnalyticsService.logEvent(
        'product_stock_movements_load_failed',
        parameters: {'product_id': productId, 'error': e.toString()},
      );
    } finally {
      loadingStockMovements.value = false;
    }
  }

  void deleteProduct() {
    Get.back();
  }
}
