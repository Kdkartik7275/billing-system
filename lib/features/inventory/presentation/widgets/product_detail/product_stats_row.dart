import 'package:billing_system/features/inventory/presentation/widgets/product_detail/detail_section_card.dart';
import 'package:flutter/material.dart';

class StockStatsRow extends StatelessWidget {
  final double totalStock;
  final double reservedStock;
  final String unit;
  final String warehouseName;

  const StockStatsRow({
    super.key,
    required this.totalStock,
    required this.reservedStock,
    required this.unit,
    required this.warehouseName,
  });

  double get availableStock => totalStock - reservedStock;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xff12B76A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      availableStock.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold, height: 1),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Available $unit',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  title: 'Total',
                  value: '${totalStock.toStringAsFixed(0)} $unit',
                  icon: Icons.layers_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoTile(
                  title: 'Reserved',
                  value: '${reservedStock.toStringAsFixed(0)} $unit',
                  icon: Icons.lock_outline,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _InfoTile(
            title: 'Warehouse',
            value: warehouseName,
            icon: Icons.storefront_outlined,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
