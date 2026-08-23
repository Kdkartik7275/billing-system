import 'package:billing_system/core/helper/print_bill.dart';
import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/widgets/bill_details_dialog.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_date_picker.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_filter_chips.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_row.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_scan_button.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_scan_qr.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_stat_bar.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesTabletLayout extends GetView<SalesController> {
  const SalesTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- LEFT: FILTERS + STATS ----------------
          SizedBox(
            width: 300,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SalesDatePicker(controller: controller),

                  const SizedBox(height: 14),

                  SalesFilterChips(controller: controller),

                  const SizedBox(height: 18),

                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      );
                    }

                    return SalesStatsBar(
                      controller: controller,
                      vertical: true,
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          // ---------------- RIGHT: SALES LIST ----------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sales List',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),

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

                const SizedBox(height: 14),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      );
                    }

                    // ---------------- BILLS ----------------
                    final bills = controller.filteredBills;

                    if (bills.isEmpty) {
                      return const Center(
                        child: Text(
                          'No sales found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    // ---------------- SALES GRID ----------------
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: bills.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 380,
                            mainAxisExtent: 112,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
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
          ),
        ],
      ),
    );
  }
}
