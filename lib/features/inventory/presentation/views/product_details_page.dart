import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/domain/entity/inventory_product_entity.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/stock_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Extensions
// ─────────────────────────────────────────────────────────────────────────────

extension StockTransactionTypeX on StockTransactionType {
  /// Is this type adding stock?
  bool get isIncoming =>
      this == StockTransactionType.purchase ||
      this == StockTransactionType.initialStock ||
      this == StockTransactionType.returnStock;

  Color get color {
    switch (this) {
      case StockTransactionType.purchase:
        return const Color(0xFF16A34A);
      case StockTransactionType.initialStock:
        return const Color(0xFF2563EB);
      case StockTransactionType.returnStock:
        return const Color(0xFF0891B2);
      case StockTransactionType.sale:
        return const Color(0xFFEA580C);
      case StockTransactionType.damage:
        return const Color(0xFFDC2626);
      case StockTransactionType.adjustment:
        return const Color(0xFF7C3AED);
    }
  }

  Color get bgColor {
    switch (this) {
      case StockTransactionType.purchase:
        return const Color(0xFFDCFCE7);
      case StockTransactionType.initialStock:
        return const Color(0xFFDBEAFE);
      case StockTransactionType.returnStock:
        return const Color(0xFFCFFAFE);
      case StockTransactionType.sale:
        return const Color(0xFFFFF7ED);
      case StockTransactionType.damage:
        return const Color(0xFFFEE2E2);
      case StockTransactionType.adjustment:
        return const Color(0xFFEDE9FE);
    }
  }

  IconData get icon {
    switch (this) {
      case StockTransactionType.purchase:
        return Icons.arrow_downward_rounded;
      case StockTransactionType.initialStock:
        return Icons.inventory_2_outlined;
      case StockTransactionType.returnStock:
        return Icons.keyboard_return_rounded;
      case StockTransactionType.sale:
        return Icons.arrow_upward_rounded;
      case StockTransactionType.damage:
        return Icons.broken_image_outlined;
      case StockTransactionType.adjustment:
        return Icons.tune_rounded;
    }
  }

  String get label {
    switch (this) {
      case StockTransactionType.purchase:
        return 'Purchase';
      case StockTransactionType.initialStock:
        return 'Initial Stock';
      case StockTransactionType.returnStock:
        return 'Return';
      case StockTransactionType.sale:
        return 'Sale';
      case StockTransactionType.damage:
        return 'Damage';
      case StockTransactionType.adjustment:
        return 'Adjustment';
    }
  }

  String get sheetTitle {
    switch (this) {
      case StockTransactionType.purchase:
        return 'Record Purchase';
      case StockTransactionType.initialStock:
        return 'Set Initial Stock';
      case StockTransactionType.returnStock:
        return 'Record Return';
      case StockTransactionType.sale:
        return 'Record Sale';
      case StockTransactionType.damage:
        return 'Record Damage';
      case StockTransactionType.adjustment:
        return 'Stock Adjustment';
    }
  }
}

extension InventoryProductX on InventoryProduct {
  Color get statusColor {
    switch (status) {
      case StockStatus.inStock:
        return const Color(0xFF16A34A);
      case StockStatus.lowStock:
        return const Color(0xFFEA580C);
      case StockStatus.outOfStock:
        return const Color(0xFFDC2626);
    }
  }

  String get statusLabel {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ProductDetailPage
// ─────────────────────────────────────────────────────────────────────────────

class ProductDetailPage extends StatefulWidget {
  final InventoryProduct product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // Replace with real data from your controller/usecase
  final List<StockTransaction> _transactions = [
    StockTransaction(
      id: 't1',
      productId: 'p1',
      type: StockTransactionType.initialStock,
      previousStock: 0,
      quantityChanged: 100,
      newStock: 100,
      notes: 'Initial stock entry',
      createdAt: DateTime(2025, 5, 20),
    ),
    StockTransaction(
      id: 't2',
      productId: 'p1',
      type: StockTransactionType.purchase,
      previousStock: 100,
      quantityChanged: 50,
      newStock: 150,
      referenceId: 'PO-2024-112',
      notes: 'Purchase order #PO-2024-112',
      createdAt: DateTime(2025, 5, 28),
    ),
    StockTransaction(
      id: 't3',
      productId: 'p1',
      type: StockTransactionType.sale,
      previousStock: 150,
      quantityChanged: -12,
      newStock: 138,
      referenceId: 'INV-0441',
      notes: 'Sale invoice #INV-0441',
      createdAt: DateTime(2025, 5, 30),
    ),
    StockTransaction(
      id: 't4',
      productId: 'p1',
      type: StockTransactionType.damage,
      previousStock: 138,
      quantityChanged: -3,
      newStock: 135,
      notes: 'Water damage in storage',
      createdAt: DateTime(2025, 6, 1),
    ),
    StockTransaction(
      id: 't5',
      productId: 'p1',
      type: StockTransactionType.returnStock,
      previousStock: 135,
      quantityChanged: 5,
      newStock: 140,
      referenceId: 'RET-0012',
      notes: 'Customer return #RET-0012',
      createdAt: DateTime(2025, 6, 3),
    ),
    StockTransaction(
      id: 't6',
      productId: 'p1',
      type: StockTransactionType.adjustment,
      previousStock: 140,
      quantityChanged: -2,
      newStock: 138,
      notes: 'Stock count correction',
      createdAt: DateTime(2025, 6, 4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Computed ──────────────────────────────────────────────────────────────

  int get _totalIn => _transactions
      .where((t) => t.type.isIncoming)
      .fold(0, (s, t) => s + t.quantityChanged);

  // Helper on transaction to check incoming via extension
  int get _totalOut => _transactions
      .where((t) => t.type == StockTransactionType.sale)
      .fold(0, (s, t) => s + t.quantityChanged.abs());

  int get _totalDamaged => _transactions
      .where((t) => t.type == StockTransactionType.damage)
      .fold(0, (s, t) => s + t.quantityChanged.abs());

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(2)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  // ── Bottom sheet ──────────────────────────────────────────────────────────

  void _showAddMovement(StockTransactionType type) {
    final qtyCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _TypeBadge(type: type),
                const SizedBox(width: 10),
                Text(
                  type.sheetTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SheetField(
              controller: qtyCtrl,
              label: 'Quantity',
              hint: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _SheetField(
              controller: noteCtrl,
              label: 'Note / Reference',
              hint: 'e.g. PO number, invoice ref…',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: type.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final qty = int.tryParse(qtyCtrl.text) ?? 0;
                  if (qty == 0) return;
                  // Outgoing types store negative qty
                  final signed = type.isIncoming ? qty.abs() : -qty.abs();
                  setState(() {
                    _transactions.insert(
                      0,
                      StockTransaction(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        productId: widget.product.id,
                        type: type,
                        previousStock: widget.product.stock,
                        quantityChanged: signed,
                        newStock: widget.product.stock + signed,
                        notes: noteCtrl.text.trim().isEmpty
                            ? null
                            : noteCtrl.text.trim(),
                        createdAt: DateTime.now(),
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [_buildAppBar(p)],
        body: Column(
          children: [
            _TabBar(controller: _tab),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _OverviewTab(product: p, fmt: _fmt),
                  _StockHistoryTab(
                    transactions: _transactions,
                    totalIn: _totalIn,
                    totalOut: _totalOut,
                    product: p,
                  ),
                  _AnalyticsTab(
                    transactions: _transactions,
                    product: p,
                    fmt: _fmt,
                    totalIn: _totalIn,
                    totalOut: _totalOut,
                    totalDamaged: _totalDamaged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _BottomActionBar(onTap: _showAddMovement),
    );
  }

  SliverAppBar _buildAppBar(InventoryProduct p) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black87,
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.black87),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (v) {
            if (v == 'delete') {
              Get.find<InventoryController>().deleteProduct(p.id);
              Get.back();
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(children: [
                Icon(Icons.edit_outlined, size: 16),
                SizedBox(width: 8),
                Text('Edit Product'),
              ]),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(children: [
                Icon(Icons.delete_outline_rounded,
                    size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ]),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Image.network(
                    p.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  p.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Chip(label: p.category, color: AppColors.primary),
                  const SizedBox(width: 6),
                  StockStatusBadge(status: p.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab bar
// ─────────────────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final TabController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Stock History'),
          Tab(text: 'Analytics'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bottom FAB row — only meaningful actions shown
//  (initialStock is a one-time setup, excluded from daily operations)
// ─────────────────────────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  final void Function(StockTransactionType) onTap;
  const _BottomActionBar({required this.onTap});

  static const _actions = [
    StockTransactionType.purchase,
    StockTransactionType.sale,
    StockTransactionType.returnStock,
    StockTransactionType.damage,
    StockTransactionType.adjustment,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _actions.asMap().entries.map((e) {
          final isLast = e.key == _actions.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 8),
              child: _ActionFAB(
                type: e.value,
                onTap: () => onTap(e.value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TAB 1 – Overview
// ─────────────────────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final InventoryProduct product;
  final String Function(double) fmt;
  const _OverviewTab({required this.product, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        Row(
          children: [
            _QuickStat(
              label: 'Price',
              value: fmt(p.price),
              icon: Icons.currency_rupee_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            _QuickStat(
              label: 'Stock',
              value: '${p.stock} ${p.stockUnit}',
              icon: Icons.inventory_outlined,
              color: p.statusColor,
            ),
            const SizedBox(width: 10),
            _QuickStat(
              label: 'Total Value',
              value: fmt(p.totalValue),
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.purple.shade600,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _InfoCard(
          title: 'Product Information',
          icon: Icons.info_outline_rounded,
          rows: [
            _Row('SKU', p.sku),
            _Row('Barcode', p.barcode),
            _Row('Category', p.category),
            _Row('Supplier', p.supplier),
            _Row('Stock Unit', p.stockUnit),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Pricing & Stock',
          icon: Icons.local_offer_outlined,
          rows: [
            _Row('Unit Price', fmt(p.price)),
            _Row('Current Stock', '${p.stock} ${p.stockUnit}'),
            _Row('Total Stock Value', fmt(p.totalValue)),
            _Row('Stock Status', p.statusLabel, valueColor: p.statusColor),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TAB 2 – Stock History
// ─────────────────────────────────────────────────────────────────────────────

class _StockHistoryTab extends StatelessWidget {
  final List<StockTransaction> transactions;
  final int totalIn;
  final int totalOut;
  final InventoryProduct product;

  const _StockHistoryTab({
    required this.transactions,
    required this.totalIn,
    required this.totalOut,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                label: 'Stock In',
                value: '+$totalIn',
                icon: Icons.arrow_downward_rounded,
                bgColor: const Color(0xFFDCFCE7),
                color: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryTile(
                label: 'Stock Out',
                value: '-$totalOut',
                icon: Icons.arrow_upward_rounded,
                bgColor: const Color(0xFFFFF7ED),
                color: const Color(0xFFEA580C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Movement Log',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        ...transactions.map(
          (t) => _TransactionTile(
            transaction: t,
            stockUnit: product.stockUnit,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TAB 3 – Analytics
// ─────────────────────────────────────────────────────────────────────────────

class _AnalyticsTab extends StatelessWidget {
  final List<StockTransaction> transactions;
  final InventoryProduct product;
  final String Function(double) fmt;
  final int totalIn;
  final int totalOut;
  final int totalDamaged;

  const _AnalyticsTab({
    required this.transactions,
    required this.product,
    required this.fmt,
    required this.totalIn,
    required this.totalOut,
    required this.totalDamaged,
  });

  @override
  Widget build(BuildContext context) {
    final turnover =
        totalIn == 0 ? 0.0 : totalOut / totalIn * 100;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        _InfoCard(
          title: 'Stock Analytics',
          icon: Icons.bar_chart_rounded,
          rows: [
            _Row('Total Purchased', '+$totalIn ${product.stockUnit}'),
            _Row('Total Sold', '-$totalOut ${product.stockUnit}'),
            _Row('Total Damaged', '-$totalDamaged ${product.stockUnit}'),
            _Row('Turnover Rate', '${turnover.toStringAsFixed(1)}%'),
            _Row('Current Stock', '${product.stock} ${product.stockUnit}'),
            _Row('Stock Value', fmt(product.totalValue)),
          ],
        ),
        const SizedBox(height: 14),
        _InfoCard(
          title: 'Movement Breakdown',
          icon: Icons.donut_small_rounded,
          rows: const [],
          customChild: Column(
            children: [
              const SizedBox(height: 6),
              _BreakdownBar(
                incoming: totalIn.toDouble(),
                outgoing: totalOut.toDouble(),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _Legend(
                    color: const Color(0xFF16A34A),
                    label: 'Purchased / Returned',
                  ),
                  _Legend(
                    color: const Color(0xFFEA580C),
                    label: 'Sold',
                  ),
                  _Legend(
                    color: const Color(0xFFDC2626),
                    label: 'Damaged',
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _InfoCard(
          title: 'Recent Activity (last 5)',
          icon: Icons.history_rounded,
          rows: transactions
              .take(5)
              .map(
                (t) => _Row(
                  t.type.label,
                  '${t.quantityChanged > 0 ? '+' : ''}${t.quantityChanged} ${product.stockUnit}',
                  valueColor: t.type.color,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared widgets
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_Row> rows;
  final Widget? customChild;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.rows,
    this.customChild,
  });

  @override
  Widget build(BuildContext context) {
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
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...rows,
          if (customChild != null) customChild!,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Row(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final StockTransaction transaction;
  final String stockUnit;

  const _TransactionTile({
    required this.transaction,
    required this.stockUnit,
  });

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final type = t.type;
    final qtyStr =
        '${t.quantityChanged > 0 ? '+' : ''}${t.quantityChanged} $stockUnit';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          _TypeBadge(type: type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.notes ?? t.referenceId ?? type.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${type.label}  ·  ${_fmtDate(t.createdAt)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                qtyStr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: type.color,
                ),
              ),
              Text(
                '→ ${t.newStock} $stockUnit',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

// Circular icon badge
class _TypeBadge extends StatelessWidget {
  final StockTransactionType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: type.bgColor, shape: BoxShape.circle),
      child: Icon(type.icon, color: type.color, size: 18),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color bgColor;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownBar extends StatelessWidget {
  final double incoming;
  final double outgoing;

  const _BreakdownBar({required this.incoming, required this.outgoing});

  @override
  Widget build(BuildContext context) {
    final total = incoming + outgoing;
    if (total == 0) {
      return Container(
        height: 14,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(7),
        ),
      );
    }
    final inFlex = (incoming / total * 100).round().clamp(1, 99);
    final outFlex = (100 - inFlex).clamp(1, 99);
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Row(
        children: [
          Expanded(
            flex: inFlex,
            child: Container(height: 14, color: const Color(0xFF16A34A)),
          ),
          Expanded(
            flex: outFlex,
            child: Container(height: 14, color: const Color(0xFFEA580C)),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionFAB extends StatelessWidget {
  final StockTransactionType type;
  final VoidCallback onTap;
  const _ActionFAB({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: type.label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: type.color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: type.color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon, color: Colors.white, size: 18),
              const SizedBox(height: 2),
              Text(
                type.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}