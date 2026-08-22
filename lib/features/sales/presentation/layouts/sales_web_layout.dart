import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_date_picker.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_filter_chips.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_row.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_search_field.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_stat_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesWebLayout extends GetView<SalesController> {
  const SalesWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 220,
                child: SalesDatePicker(controller: controller),
              ),

              const SizedBox(width: 16),

              Expanded(child: SalesFilterChips(controller: controller)),

              const SizedBox(width: 16),

              SizedBox(
                width: 320,
                child: SalesSearchField(onChanged: controller.updateSearch),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SalesStatsBar(controller: controller),

          const SizedBox(height: 24),

          Text('Sales List', style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 12),

          Expanded(
            child: Obx(() {
              // ---------------- LOADING ----------------
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                );
              }

              // ---------------- BILLS ----------------
              final bills = controller.filteredBills;

              // ---------------- EMPTY STATE ----------------
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
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 480,
                  mainAxisExtent: 130,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (_, index) {
                  return SaleRow(bill: bills[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
