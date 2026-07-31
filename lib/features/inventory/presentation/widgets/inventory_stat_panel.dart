import 'package:flutter/material.dart';

import '../../../../core/config/theme/app_radius.dart';

class InventoryStatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const InventoryStatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class InventoryStatsPanel extends StatelessWidget {
  final List<InventoryStatItem> items;

  const InventoryStatsPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xffE9EBEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 640;
          final columns = wide ? items.length : 2;
          return _StatGrid(items: items, columns: columns);
        },
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final List<InventoryStatItem> items;
  final int columns;

  const _StatGrid({required this.items, required this.columns});

  @override
  Widget build(BuildContext context) {
    final rows = <List<InventoryStatItem>>[];
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
                  Expanded(child: _StatSegment(item: rows[r][c])),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatSegment extends StatelessWidget {
  final InventoryStatItem item;

  const _StatSegment({required this.item});

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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff111827),
                      letterSpacing: -.4,
                      height: 1,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
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
