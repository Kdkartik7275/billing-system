import 'package:billing_system/features/inventory/domain/entities/stock_batch_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/detail_section_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BatchSummaryTable extends StatelessWidget {
  final List<StockBatchEntity> batches;
  final VoidCallback? onViewAll;
  final int? maxRows;

  const BatchSummaryTable({
    super.key,
    required this.batches,
    this.onViewAll,
    this.maxRows,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final rows = maxRows != null ? batches.take(maxRows!).toList() : batches;

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
          if (rows.isEmpty)
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
                dataTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
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
