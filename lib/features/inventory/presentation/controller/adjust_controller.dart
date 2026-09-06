import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/adjust_stock_usecase.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdjustStockController extends GetxController {
  final ProductEntity product;
  final AdjustStockUsecase adjustStockUsecase;

  AdjustStockController({
    required this.product,
    required this.adjustStockUsecase,
  });

  // ---------------- TEXT CONTROLLERS ----------------
  final quantityController = TextEditingController();
  final notesController = TextEditingController();

  // ---------------- REACTIVE FIELDS ----------------
  final Rx<String?> warehouseId = Rx<String?>(null);
  final Rx<AdjustmentDirection> direction = AdjustmentDirection.increase.obs;
  final Rx<StockMovementType> reasonType = StockMovementType.adjustment.obs;

  final RxDouble quantity = 0.0.obs;

  // ---------------- SAVE STATE ----------------
  final RxBool isSaving = false.obs;

  static const reasonOptions = <StockMovementType, String>{
    StockMovementType.adjustment: 'Stock Correction',
    StockMovementType.damaged: 'Damaged',
    StockMovementType.expired: 'Expired',
  };

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('AdjustStock');
  }

  void onQuantityChanged(String value) =>
      quantity.value = double.tryParse(value) ?? 0;

  bool get isFormValid => warehouseId.value != null && quantity.value > 0;

  Future<void> saveAdjustment() async {
    if (isSaving.value) return;

    if (!isFormValid) {
      AppSnackbar.error(message: 'Please fill all required fields');
      return;
    }

    isSaving.value = true;

    try {
      final result = await adjustStockUsecase.call(
        AdjustStockParams(
          productId: product.id,
          warehouseId: warehouseId.value!,
          direction: direction.value,
          quantity: quantity.value,
          reasonType: reasonType.value,
          notes: notesController.text.trim(),
        ),
      );

      result.fold(
        (failure) {
          AppSnackbar.error(message: failure.message);

          AnalyticsService.logEvent(
            'stock_adjustment_failed',
            parameters: {'product_id': product.id, 'reason': failure.message},
          );
        },
        (_) {
          final inventoryController = Get.find<InventoryController>();
          final currentQuantity = inventoryController.stockQuantityFor(
            product.id,
          );
          final delta = direction.value == AdjustmentDirection.increase
              ? quantity.value
              : -quantity.value;
          final newQuantity = currentQuantity + delta;

          inventoryController.updateStockQuantityLocally(
            product.id,
            newQuantity < 0 ? 0 : newQuantity,
          );

          Get.back(result: true);
          AppSnackbar.success(message: 'Stock adjusted successfully');

          AnalyticsService.logEvent(
            'stock_adjustment_success',
            parameters: {
              'product_id': product.id,
              'direction': direction.value.name,
              'quantity': quantity.value,
              'reason_type': reasonType.value.name,
            },
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Adjust stock failed: $e');
      debugPrint(stackTrace.toString());
      AppSnackbar.error(message: 'Something went wrong. Please try again.');

      AnalyticsService.logEvent(
        'stock_adjustment_failed',
        parameters: {'product_id': product.id, 'error': e.toString()},
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    quantityController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
