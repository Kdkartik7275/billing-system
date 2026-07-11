import 'package:flutter/material.dart';

class BreakdownBar extends StatelessWidget {
  final double incoming;
  final double outgoing;

  const BreakdownBar({
    super.key,
    required this.incoming,
    required this.outgoing,
  });

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
