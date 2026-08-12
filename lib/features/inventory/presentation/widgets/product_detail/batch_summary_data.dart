import 'package:billing_system/core/card/detail_section_card.dart';
import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BatchSummaryTable extends GetView<ProductDetailController> {
  final VoidCallback? onViewAll;
  final int? maxRows;

  const BatchSummaryTable({super.key, this.onViewAll, this.maxRows});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');

    return Obx(() {
      final rows = maxRows != null
          ? controller.stockBatches.take(maxRows!).toList()
          : controller.stockBatches;

      return DetailSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              icon: Icons.inventory_outlined,
              title: 'Batch Summary',
              onViewAll: onViewAll,
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            if (controller.loadingStockBatches.value)
              const _BatchSummaryTableSkeleton()
            else if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No batches recorded yet',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 12.5,
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 34,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 44,
                  columnSpacing: 22,
                  headingTextStyle: Theme.of(context).textTheme.bodySmall!
                      .copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                  dataTextStyle: Theme.of(context).textTheme.bodySmall!
                      .copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                  columns: const [
                    DataColumn(label: Text('Batch No.')),
                    DataColumn(label: Text('Qty')),
                    DataColumn(label: Text('Purchase Price')),
                    DataColumn(label: Text('MFG Date')),
                    DataColumn(label: Text('EXP Date')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: rows.map((batch) {
                    return DataRow(
                      cells: [
                        DataCell(Text(batch.batchNumber)),
                        DataCell(Text(batch.quantity.toStringAsFixed(0))),
                        DataCell(
                          Text('₹${batch.purchasePrice.toStringAsFixed(2)}'),
                        ),
                        DataCell(
                          Text(
                            batch.manufactureDate != null
                                ? dateFmt.format(batch.manufactureDate!)
                                : '—',
                          ),
                        ),
                        DataCell(
                          Text(
                            batch.expiryDate != null
                                ? dateFmt.format(batch.expiryDate!)
                                : '—',
                          ),
                        ),
                        DataCell(_BatchStatusChip(batch: batch)),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _BatchSummaryTableSkeleton extends StatefulWidget {
  const _BatchSummaryTableSkeleton();

  @override
  State<_BatchSummaryTableSkeleton> createState() =>
      _BatchSummaryTableSkeletonState();
}

class _BatchSummaryTableSkeletonState extends State<_BatchSummaryTableSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: List.generate(2, (rowIndex) {
              final offset = (rowIndex * 0.12) % 1.0;
              final progress = (_controller.value + offset) % 1.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    _skeletonBar(width: 90, progress: progress), // Batch No.
                    const SizedBox(width: 22),
                    _skeletonBar(width: 36, progress: progress), // Qty
                    const SizedBox(width: 22),
                    _skeletonBar(
                      width: 84,
                      progress: progress,
                    ), // Purchase Price
                    const SizedBox(width: 22),
                    _skeletonBar(width: 76, progress: progress), // MFG Date
                    const SizedBox(width: 22),
                    _skeletonBar(width: 76, progress: progress), // EXP Date
                    const SizedBox(width: 22),
                    _skeletonBar(
                      width: 74,
                      progress: progress,
                      height: 20,
                    ), // Status chip
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _skeletonBar({
    required double width,
    required double progress,
    double height = 14,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment(-1 + progress * 2.5, 0),
          end: Alignment(0.2 + progress * 2.5, 0),
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade100,
            Colors.grey.shade200,
          ],
          stops: const [0.1, 0.5, 0.9],
        ),
      ),
    );
  }
}

class _BatchStatusChip extends StatelessWidget {
  final StockBatchEntity batch;

  const _BatchStatusChip({required this.batch});

  @override
  Widget build(BuildContext context) {
    final label = batch.isExpired
        ? 'Expired'
        : batch.isExpiringSoon()
        ? 'Expiring Soon'
        : 'Active';
    final color = batch.isExpired
        ? Colors.red.shade600
        : batch.isExpiringSoon()
        ? Colors.orange.shade700
        : const Color(0xFF12B76A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
