import 'package:billing_system/core/helper/print_bill.dart';
import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/widgets/bill_details_dialog.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_date_picker.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_export_button.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_filter_chips.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_row.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_scan_button.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_scan_qr.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_stat_bar.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesMobileLayout extends GetView<SalesController> {
  const SalesMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          SalesDatePicker(controller: controller),

          const SizedBox(height: 14),

          SalesFilterChips(controller: controller),

          const SizedBox(height: 16),

          // Everything above the list has fixed height.
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              );
            }

            return SalesStatsBar(controller: controller);
          }),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Sales List',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              SalesExportButton(controller: controller),

              const SizedBox(width: 10),

              SalesScanButton(
                onPressed: () async {
                  final result = await Get.to<String>(
                    () => const SalesQrScannerPage(),
                  );

                  if (result == null || result.isEmpty) {
                    return;
                  }

                  await controller.handleScannedBill(result);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ----------------------------------------------------------
          // BILL LIST
          // ----------------------------------------------------------
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                );
              }

              final bills = controller.filteredBills;

              if (bills.isEmpty) {
                return const Center(
                  child: Text(
                    'No sales found',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: bills.length,
                itemBuilder: (_, index) {
                  final bill = bills[index];

                  return InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => BillDetailsDialog(
                        bill: bill,
                        onPrintReceipt: () => printBill(
                          bill: bill,
                          shop: Get.find<UserController>().shop.value!,
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: SaleRow(bill: bill),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
