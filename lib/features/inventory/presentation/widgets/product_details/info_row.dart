import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow(this.label, this.value, {super.key, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
