import 'package:billing_system/core/sync/widgets/sync_details_sheet.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncStatusPill extends StatelessWidget {
  const SyncStatusPill({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillingController>();

    return Obx(() {
      final pending = controller.pending.length;
      final syncing = controller.syncing.value;
      final idle = pending == 0 && !syncing;

      final Color fg = idle
          ? const Color(0xFF16A34A)
          : (syncing ? const Color(0xFF2563EB) : const Color(0xFFEA580C));

      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const SyncDetailsSheet(),
          ),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
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
                        idle ? Icons.check_circle_rounded : Icons.cloud_off_rounded,
                        size: 15,
                        color: fg,
                      ),
                const SizedBox(width: 6),
                Text(
                  syncing
                      ? 'Syncing $pending...'
                      : (idle ? 'Synced' : '$pending offline'),
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
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