import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:billing_system/features/pos/presentation/pages/barcode_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFieldAndScanner extends StatelessWidget {
  const SearchFieldAndScanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final textController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: textController,
              onChanged: controller.updateSearch,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search products, SKU, or scan barcode...',
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            textController.clear();
                            controller.clearSearch();
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 44,
          child: ElevatedButton.icon(
            // Navigate to the full-screen scanner page
            onPressed: () => Get.to(() => const BarcodeScannerPage()),
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 20,
              color: Colors.white,
            ),
            label: const Text(
              'SCAN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
