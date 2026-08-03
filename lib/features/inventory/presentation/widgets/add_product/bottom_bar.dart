import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/inventory/presentation/controller/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ProductActionButtons extends StatelessWidget {
  final AddProductController controller;

  const ProductActionButtons({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          if (!controller.isSaving.value)
            Expanded(
              child: OutlinedButton(
                onPressed: controller.cancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),

          if (!controller.isSaving.value)
            const SizedBox(width: 10),

          if (controller.isEditMode && !controller.isSaving.value) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.deleteProduct,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE5484D),
                  side: const BorderSide(color: Color(0xFFE5484D)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Delete Product',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: const Color(0xFFE5484D),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],

          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : (controller.isEditMode
                        ? controller.updateProduct
                        : controller.addProduct),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: controller.isSaving.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Text(
                      controller.isEditMode
                          ? 'Save Changes'
                          : 'Add Product',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}