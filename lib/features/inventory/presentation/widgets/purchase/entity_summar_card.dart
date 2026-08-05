import 'package:billing_system/features/inventory/presentation/widgets/product_detail/status_pill.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EntitySummaryHeader extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String subtitle;
  final bool isActive;

  const EntitySummaryHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 56,
              height: 56,
              color: Colors.white,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.contain)
                  : Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey.shade400,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          StatusPill(
            label: isActive ? 'Active' : 'Inactive',
            color: isActive ? const Color(0xFF12B76A) : Colors.grey,
          ),
        ],
      ),
    );
  }
}
