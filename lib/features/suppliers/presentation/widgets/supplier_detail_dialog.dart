import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> showSupplierDetailDialog(
  BuildContext context, {
  required SupplierListItem supplier,
  VoidCallback? onCall,
  VoidCallback? onOpenMap,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => _SupplierDetailDialog(
      supplier: supplier,
      onCall: onCall,
      onOpenMap: onOpenMap,
    ),
  );
}

enum _SupplierDetailTab { details, purchases }

class _SupplierDetailDialog extends StatefulWidget {
  final SupplierListItem supplier;
  final VoidCallback? onCall;
  final VoidCallback? onOpenMap;

  const _SupplierDetailDialog({
    required this.supplier,
    this.onCall,
    this.onOpenMap,
  });

  @override
  State<_SupplierDetailDialog> createState() => _SupplierDetailDialogState();
}

class _SupplierDetailDialogState extends State<_SupplierDetailDialog> {
  final SuppliersController controller = Get.find<SuppliersController>();

  _SupplierDetailTab _tab = _SupplierDetailTab.details;

  bool _purchasesRequested = false;

  SupplierListItem get supplier => widget.supplier;

  void _onTabChanged(_SupplierDetailTab tab) {
    setState(() => _tab = tab);

    // Lazy-load: only hit the repository the first time Purchases is opened.
    if (tab == _SupplierDetailTab.purchases && !_purchasesRequested) {
      _purchasesRequested = true;
      controller.loadPurchasesForSupplier(supplier.supplierId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 480 ? screenWidth * 0.92 : 420.0;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---------------- HEADER ----------------
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: supplier.avatarBgColor,
                    child: Text(
                      supplier.initials,
                      style: theme.titleMedium!.copyWith(
                        color: supplier.avatarColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: supplier.isActive
                                ? const Color(0xFFE6F5EB)
                                : const Color(0xFFF0F1F3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            supplier.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: supplier.isActive
                                  ? const Color(0xFF1B8A4C)
                                  : const Color(0xFF6B7076),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ---------------- TAB SWITCHER ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _TabButton(
                      label: 'Details',
                      selected: _tab == _SupplierDetailTab.details,
                      onTap: () => _onTabChanged(_SupplierDetailTab.details),
                    ),
                    _TabButton(
                      label: 'Purchases',
                      selected: _tab == _SupplierDetailTab.purchases,
                      onTap: () => _onTabChanged(_SupplierDetailTab.purchases),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- TAB CONTENT ----------------
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _tab == _SupplierDetailTab.details
                      ? _DetailsTab(
                          key: const ValueKey('details'),
                          supplier: supplier,
                          onCall: widget.onCall,
                          onOpenMap: widget.onOpenMap,
                        )
                      : _PurchasesTab(
                          key: const ValueKey('purchases'),
                          controller: controller,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DETAILS TAB
// ---------------------------------------------------------------------------

class _DetailsTab extends StatelessWidget {
  final SupplierListItem supplier;
  final VoidCallback? onCall;
  final VoidCallback? onOpenMap;

  const _DetailsTab({
    super.key,
    required this.supplier,
    this.onCall,
    this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: theme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _TappableInfoRow(
                icon: Icons.call_rounded,
                label: 'Phone',
                value: supplier.phone,
                trailing: _SmallCallButton(onTap: onCall),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _TappableInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: supplier.location,
                multiline: true,
                onTap: onOpenMap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TappableInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final bool multiline;
  final VoidCallback? onTap;

  const _TappableInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.multiline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: multiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 17, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            SizedBox(
              width: 60,
              child: Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: multiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleSmall!.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}

class _SmallCallButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _SmallCallButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF1B8A4C).withValues(alpha: 0.1)
              : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.call_rounded,
          size: 14,
          color: enabled ? const Color(0xFF1B8A4C) : Colors.grey.shade400,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PURCHASES TAB
// ---------------------------------------------------------------------------

class _PurchasesTab extends StatelessWidget {
  final SuppliersController controller;

  const _PurchasesTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Obx(() {
      if (controller.isLoadingSupplierPurchases.value) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 34),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Center(
            child: SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      final purchases = controller.supplierPurchases;

      if (purchases.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 26,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                'No purchases yet',
                style: theme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Purchases from this supplier will appear here',
                style: theme.bodySmall!.copyWith(
                  fontSize: 11.5,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }

      final totalAmount = purchases.fold<double>(
        0,
        (sum, purchase) => sum + purchase.subtotal,
      );

      final totalDue = purchases.fold<double>(
        0,
        (sum, purchase) => sum + purchase.dueAmount,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- summary strip (one block, divided) ----
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE3EDE7)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  _SummaryCell(
                    label: 'Purchases',
                    value: '${purchases.length}',
                    color: Colors.black87,
                  ),
                  _summaryDivider(),
                  _SummaryCell(
                    label: 'Total Value',
                    value: '₹${_compact(totalAmount)}',
                    color: const Color(0xFF1B8A4C),
                  ),
                  _summaryDivider(),
                  _SummaryCell(
                    label: 'Outstanding',
                    value: '₹${_compact(totalDue)}',
                    color: totalDue > 0
                        ? const Color(0xFFE23744)
                        : Colors.black87,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'All Purchases',
            style: theme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),

          // ---- purchase list ----
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: purchases.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final purchase = purchases[index];

                return _PurchaseRow(purchase: purchase);
              },
            ),
          ),
        ],
      );
    });
  }

  static Widget _summaryDivider() =>
      Container(width: 1, color: const Color(0xFFE3EDE7));

  static String _compact(double value) {
    if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PurchaseRow extends StatefulWidget {
  final PurchaseEntity purchase;

  const _PurchaseRow({required this.purchase});

  @override
  State<_PurchaseRow> createState() => _PurchaseRowState();
}

class _PurchaseRowState extends State<_PurchaseRow> {
  bool _expanded = false;

  PurchaseEntity get purchase => widget.purchase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final dateFmt = DateFormat('dd MMM yyyy');

    final isPaid = purchase.dueAmount <= 0;
    final accent = isPaid ? const Color(0xFF1B8A4C) : const Color(0xFFE23744);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _expanded
              ? accent.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // ---------------- COLLAPSED HEADER ----------------
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      isPaid
                          ? Icons.check_circle_outline_rounded
                          : Icons.schedule_rounded,
                      size: 15,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purchase.invoiceNumber.isNotEmpty
                              ? purchase.invoiceNumber
                              : '₹${purchase.subtotal.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateFmt.format(purchase.purchaseDate),
                          style: theme.bodySmall!.copyWith(
                            fontSize: 11.5,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${purchase.subtotal.toStringAsFixed(2)}',
                        style: theme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isPaid
                            ? 'Paid'
                            : '₹${purchase.dueAmount.toStringAsFixed(0)} due',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------- EXPANDED DETAILS ----------------
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  Divider(height: 16, color: Colors.grey.shade200),

                  _PurchaseDetailLine(
                    label: 'Quantity',
                    value: '${purchase.quantity}',
                  ),
                  _PurchaseDetailLine(
                    label: 'Unit Price',
                    value: '₹${purchase.price.toStringAsFixed(2)}',
                  ),
                  if (purchase.discount > 0)
                    _PurchaseDetailLine(
                      label: 'Discount',
                      value: '-₹${purchase.discount.toStringAsFixed(2)}',
                      valueColor: const Color(0xFF1B8A4C),
                    ),
                  if (purchase.tax > 0)
                    _PurchaseDetailLine(
                      label: 'Tax',
                      value: '₹${purchase.tax.toStringAsFixed(2)}',
                    ),
                  _PurchaseDetailLine(
                    label: 'Paid',
                    value: '₹${(purchase.paidAmount ?? 0).toStringAsFixed(2)}',
                    valueColor: const Color(0xFF1B8A4C),
                  ),

                  Divider(height: 16, color: Colors.grey.shade200),

                  _PurchaseDetailLine(
                    label: 'Bill Date',
                    value: dateFmt.format(purchase.billDate),
                  ),
                  _PurchaseDetailLine(
                    label: 'Due Date',
                    value: dateFmt.format(purchase.dueDate),
                    valueColor: isPaid ? null : accent,
                  ),
                  _PurchaseDetailLine(
                    label: 'Payment',
                    value: purchase.paymentMethod,
                  ),
                  if (purchase.batchNumber.isNotEmpty)
                    _PurchaseDetailLine(
                      label: 'Batch',
                      value: purchase.batchNumber,
                    ),

                  if (purchase.notes != null &&
                      purchase.notes!.trim().isNotEmpty) ...[
                    Divider(height: 16, color: Colors.grey.shade200),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        purchase.notes!,
                        style: theme.bodySmall!.copyWith(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _PurchaseDetailLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PurchaseDetailLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// TAB BUTTON
// ---------------------------------------------------------------------------

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? const Color(0xFF1B8A4C) : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
