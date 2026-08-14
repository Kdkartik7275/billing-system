import 'package:flutter/material.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';

class SupplierStatsCard extends StatelessWidget {
  final int totalSuppliers;
  final int activeSuppliers;
  final String totalPurchases;
  final String totalDue;
  final int suppliersWithDue;

  const SupplierStatsCard({
    super.key,
    required this.totalSuppliers,
    required this.activeSuppliers,
    required this.totalPurchases,
    required this.totalDue,
    required this.suppliersWithDue,
  });

  @override
  Widget build(BuildContext context) {
    final activePercent = totalSuppliers == 0
        ? 0
        : ((activeSuppliers / totalSuppliers) * 100).round();

    final items = [
      SupplierStatItem(
        title: 'Total Suppliers',
        value: '$totalSuppliers',
        growth: 'All suppliers',
        icon: Icons.groups_rounded,
        color: const Color(0xFF1B8A4C),
      ),
      SupplierStatItem(
        title: 'Active Suppliers',
        value: '$activeSuppliers',
        growth: '$activePercent% active',
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFF2F6FE4),
      ),
      SupplierStatItem(
        title: 'Total Purchases',
        value: totalPurchases,
        growth: 'This month',
        icon: Icons.inventory_2_rounded,
        color: const Color(0xFFF7941D),
      ),
      SupplierStatItem(
        title: 'Total Due',
        value: totalDue,
        growth: 'From $suppliersWithDue suppliers',
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFF8B5CF6),
        valueColor: const Color(0xFFE23744),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 640;
          final columns = wide ? items.length : 2;

          return _SupplierStatGrid(items: items, columns: columns);
        },
      ),
    );
  }
}

class SupplierStatItem {
  final String title;
  final String value;
  final String growth;
  final IconData icon;
  final Color color;
  final Color? valueColor;

  const SupplierStatItem({
    required this.title,
    required this.value,
    required this.growth,
    required this.icon,
    required this.color,
    this.valueColor,
  });
}

class _SupplierStatGrid extends StatelessWidget {
  final List<SupplierStatItem> items;
  final int columns;

  const _SupplierStatGrid({required this.items, required this.columns});

  @override
  Widget build(BuildContext context) {
    final rows = <List<SupplierStatItem>>[];

    for (var i = 0; i < items.length; i += columns) {
      final end = (i + columns > items.length) ? items.length : i + columns;

      rows.add(items.sublist(i, end));
    }

    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r != 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade200,
              ),
            ),

          IntrinsicHeight(
            child: Row(
              children: [
                for (var c = 0; c < rows[r].length; c++) ...[
                  if (c != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),

                  Expanded(child: _SupplierStatSegment(item: rows[r][c])),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SupplierStatSegment extends StatelessWidget {
  final SupplierStatItem item;

  const _SupplierStatSegment({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: Colors.white, size: 16),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.value,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: item.valueColor ?? const Color(0xff111827),
                      letterSpacing: -.4,
                      height: 1,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.growth,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
