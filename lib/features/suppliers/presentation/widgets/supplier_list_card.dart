import 'package:flutter/material.dart';

class SupplierListItem {
  final String initials;
  final Color avatarColor;
  final Color avatarBgColor;
  final String name;
  final String phone;
  final String location;
  final bool isActive;

  const SupplierListItem({
    required this.initials,
    required this.avatarColor,
    required this.avatarBgColor,
    required this.name,
    required this.phone,
    required this.location,
    required this.isActive,
  });
}

class SupplierListCard extends StatelessWidget {
  final List<SupplierListItem> suppliers;
  final ValueChanged<SupplierListItem>? onTapSupplier;
  final ValueChanged<SupplierListItem>? onTapMore;

  const SupplierListCard({
    super.key,
    required this.suppliers,
    this.onTapSupplier,
    this.onTapMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < suppliers.length; i++) ...[
            _SupplierTile(
              supplier: suppliers[i],
              onTap: onTapSupplier == null
                  ? null
                  : () => onTapSupplier!(suppliers[i]),
              onTapMore: onTapMore == null
                  ? null
                  : () => onTapMore!(suppliers[i]),
            ),
            if (i != suppliers.length - 1)
              const Divider(height: 1, color: Color(0xFFF0F1F3)),
          ],
        ],
      ),
    );
  }
}

class _SupplierTile extends StatelessWidget {
  final SupplierListItem supplier;
  final VoidCallback? onTap;
  final VoidCallback? onTapMore;

  const _SupplierTile({required this.supplier, this.onTap, this.onTapMore});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: supplier.avatarBgColor,
              child: Text(
                supplier.initials,
                style: TextStyle(
                  color: supplier.avatarColor,
                  fontWeight: FontWeight.w700,
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
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1C1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.call_rounded,
                        size: 14,
                        color: Color(0xFF8B909A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        supplier.phone,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7076),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF8B909A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        supplier.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7076),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: supplier.isActive
                          ? const Color(0xFF1B8A4C)
                          : const Color(0xFF6B7076),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: onTapMore,
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF8B909A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
