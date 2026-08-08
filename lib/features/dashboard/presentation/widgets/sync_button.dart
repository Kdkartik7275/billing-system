import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncButton extends StatelessWidget {
  const SyncButton({super.key, required this.billsController});
  final BillingController billsController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pending = billsController.pending.length;
      final syncing = billsController.syncing.value;
      final idle = pending == 0 && !syncing;

      final Color fg = idle
          ? const Color(0xFF16A34A)
          : (syncing ? AppColors.primary : const Color(0xFFEA580C));

      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: syncing ? null : () => billsController.syncBills(),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                syncing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(fg),
                        ),
                      )
                    : Icon(
                        idle ? Icons.check_circle_rounded : Icons.sync_rounded,
                        size: 16,
                        color: fg,
                      ),
                const SizedBox(width: 7),
                Text(
                  syncing
                      ? 'Syncing…'
                      : (idle ? 'Synced' : 'Sync $pending pending'),
                  style: TextStyle(
                    color: fg,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
