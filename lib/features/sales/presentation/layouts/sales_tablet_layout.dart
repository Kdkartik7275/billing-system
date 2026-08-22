import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_date_picker.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_filter_chips.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_row.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_search_field.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_stat_bar.dart';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SalesDatePicker(controller: controller),

                const SizedBox(height: 14),

                SalesFilterChips(controller: controller),

                const SizedBox(height: 16),

                SalesStatsBar(controller: controller),

                const SizedBox(height: 20),

                SalesSearchField(onChanged: controller.updateSearch),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // ---------------- RIGHT: SALES LIST ----------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales List',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),

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

                    // ---------------- SALES LIST ----------------
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: bills.length,
                      itemBuilder: (_, index) {
                        return SaleRow(bill: bills[index]);
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
