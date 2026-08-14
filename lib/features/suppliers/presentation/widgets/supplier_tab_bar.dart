import 'package:flutter/material.dart';

enum SupplierTab { all, active, inactive }

class SupplierTabBar extends StatefulWidget {
  final SupplierTab initialTab;
  final ValueChanged<SupplierTab>? onChanged;

  const SupplierTabBar({
    super.key,
    this.initialTab = SupplierTab.all,
    this.onChanged,
  });

  @override
  State<SupplierTabBar> createState() => _SupplierTabBarState();
}

class _SupplierTabBarState extends State<SupplierTabBar> {
  late SupplierTab _selected = widget.initialTab;

  void _select(SupplierTab tab) {
    setState(() => _selected = tab);
    widget.onChanged?.call(tab);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'All Suppliers',
            selected: _selected == SupplierTab.all,
            onTap: () => _select(SupplierTab.all),
          ),
          _TabItem(
            label: 'Active',
            selected: _selected == SupplierTab.active,
            onTap: () => _select(SupplierTab.active),
          ),
          _TabItem(
            label: 'Inactive',
            selected: _selected == SupplierTab.inactive,
            onTap: () => _select(SupplierTab.inactive),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: selected
                ? Border.all(color: const Color(0xFF1B8A4C))
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected
                  ? const Color(0xFF1B8A4C)
                  : const Color(0xFF6B7076),
            ),
          ),
        ),
      ),
    );
  }
}
