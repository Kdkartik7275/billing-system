import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_batch_entity.dart';
import 'package:flutter/material.dart';

class StockBatchesCard extends StatelessWidget {
  final List<StockBatch> batches;
  final String Function(double) fmt;

  const StockBatchesCard({super.key, required this.batches, required this.fmt});

  @override
  Widget build(BuildContext context) {
    if (batches.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No stock batches',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Stock Batches',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: batches.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final batch = batches[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: index == 0 ? 8 : 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Batch #${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _formatDate(batch.receivedDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _BatchDetail(
                            label: 'Quantity',
                            value: '${batch.quantityRemaining}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _BatchDetail(
                            label: 'Purchase Price',
                            value: fmt(batch.purchasePrice),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _BatchDetail(
                            label: 'Selling Price',
                            value: fmt(batch.sellingPrice),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _BatchDetail(
                            label: 'Batch Value',
                            value: fmt(
                              batch.purchasePrice * batch.quantityRemaining,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _BatchDetail extends StatelessWidget {
  final String label;
  final String value;

  const _BatchDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
