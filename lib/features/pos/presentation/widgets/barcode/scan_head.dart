import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScannerTopBar extends StatelessWidget {
  final bool torchOn;
  final VoidCallback onTorchToggle;
  final VoidCallback onClose;

  const ScannerTopBar({
    super.key,
    required this.torchOn,
    required this.onTorchToggle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          _CircleBtn(icon: Icons.arrow_back_rounded, onTap: onClose),
          const SizedBox(width: 12),
          const Text(
            'Scan & Add to Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          _CircleBtn(
            icon: torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            active: torchOn,
            onTap: onTorchToggle,
          ),
          const SizedBox(width: 8),
          Obx(() {
            final c = Get.find<CartController>().cartItems.fold<int>(
              0,
              (s, i) => s + i.quantity,
            );
            if (c == 0) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '$c',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _CircleBtn({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: active ? AppColors.primary : Colors.white),
      ),
    );
  }
}