import 'package:billing_system/features/inventory/domain/entities/stock_movement_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_detail/detail_section_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StockMovementTable extends StatelessWidget {
  final List<StockMovementEntity> movements;
  final VoidCallback? onViewAll;
  final int? maxRows;
  final String title;

  const StockMovementTable({
    super.key,
    required this.movements,
    this.onViewAll,
    this.maxRows,
    this.title = 'Recent Stock Movements',
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy, hh:mm a');
    final rows = maxRows != null
        ? movements.take(maxRows!).toList()
        : movements;

    return DetailSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.swap_horiz_rounded,
            title: title,
            onViewAll: onViewAll,
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No stock movements recorded yet',
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
                  DataColumn(label: Text('Date & Time')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Qty Change')),
                  DataColumn(label: Text('Resulting Stock')),
                ],
                rows: rows.map((movement) {
                  return DataRow(
                    cells: [
                      DataCell(Text(dateFmt.format(movement.createdAt))),
                      DataCell(_MovementTypeChip(type: movement.type)),
                      DataCell(
                        Text(
                          '${movement.isInbound ? '+' : ''}${movement.quantityChange.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: movement.isInbound
                                ? const Color(0xFF12B76A)
                                : Colors.red.shade600,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(movement.resultingQuantity.toStringAsFixed(0)),
                      ),
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

class _MovementTypeChip extends StatelessWidget {
  final StockMovementType type;

  const _MovementTypeChip({required this.type});

  String get _label {
    switch (type) {
      case StockMovementType.purchaseIn:
        return 'Purchase In';
      case StockMovementType.saleOut:
        return 'Sale Out';
      case StockMovementType.transferIn:
        return 'Transfer In';
      case StockMovementType.transferOut:
        return 'Transfer Out';
      case StockMovementType.adjustment:
        return 'Adjustment';
      case StockMovementType.returnIn:
        return 'Return In';
      case StockMovementType.returnOut:
        return 'Return Out';
      case StockMovementType.damaged:
        return 'Damaged';
      case StockMovementType.expired:
        return 'Expired';
    }
  }

  Color get _color {
    switch (type) {
      case StockMovementType.purchaseIn:
      case StockMovementType.returnIn:
        return const Color(0xFF12B76A);
      case StockMovementType.saleOut:
      case StockMovementType.transferOut:
      case StockMovementType.damaged:
      case StockMovementType.expired:
        return Colors.red.shade600;
      case StockMovementType.adjustment:
        return Colors.orange.shade700;
      case StockMovementType.transferIn:
      case StockMovementType.returnOut:
        return Colors.blue.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _color,
        ),
      ),
    );
  }
}
