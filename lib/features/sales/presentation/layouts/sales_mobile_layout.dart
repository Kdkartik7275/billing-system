import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_date_picker.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_filter_chips.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_row.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_search_field.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_stat_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesMobileLayout extends GetView<SalesController> {
  const SalesMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const SizedBox(height: 16),

        SalesDatePicker(controller: controller),
        const SizedBox(height: 14),

        SalesFilterChips(controller: controller),
        const SizedBox(height: 16),

        Obx(() {
          if (controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final bills = controller.filteredBills;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SalesStatsBar(controller: controller),
              const SizedBox(height: 20),

              Text(
                'Sales List',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 10),

              SalesSearchField(onChanged: controller.updateSearch),

              const SizedBox(height: 16),

              if (bills.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Text(
                      'No sales found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...bills.map((bill) => SaleRow(bill: bill)),
            ],
          );
        }),
      ],
    );
  }
}
