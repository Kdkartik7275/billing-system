import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SyncDetailsSheet extends StatelessWidget {
  const SyncDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillingController>();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Sync status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 4),

              // Last sync time
              Obx(() {
                final last = controller.lastSyncedAt.value;

                return Text(
                  last == null
                      ? 'Not synced yet'
                      : 'Last synced ${DateFormat.jm().format(last)}',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                );
              }),

              const SizedBox(height: 16),

              // Pending bills
              Obx(() {
                final bills = controller.pending;

                if (bills.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_done_outlined,
                          size: 32,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Everything is synced',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: bills.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (_, i) {
                      final bill = bills[i];

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 2,
                        ),
                        title: Text(
                          bill.billNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '₹${bill.grandTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: Text(
                          DateFormat.jm().format(bill.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Retry button
              Obx(() {
                final syncing = controller.syncing.value;

                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: syncing ? null : () => controller.syncBills(),
                    child: Text(
                      syncing ? 'Syncing...' : 'Retry now',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
