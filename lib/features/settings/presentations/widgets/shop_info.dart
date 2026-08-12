
import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/info_row.dart';
import 'package:flutter/material.dart';


class BusinessDetailsCard extends StatelessWidget {
  final VoidCallback? onEdit;
  const BusinessDetailsCard({super.key, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            icon: Icons.assignment_outlined,
            iconBg: const Color(0xFFEDE7FE),
            iconColor: const Color(0xFF7C5CFC),
            title: 'Business Details',
            onEdit: onEdit,
          ),
          const SizedBox(height: 8),
          const InfoRow(
            icon: Icons.badge_outlined,
            label: 'GST Number',
            value: '29ABCDE1234F1Z5',
          ),
          const InfoRow(
            icon: Icons.badge_outlined,
            label: 'PAN Number',
            value: 'ABCDE1234F',
          ),
          const InfoRow(
            icon: Icons.apartment_outlined,
            label: 'Business Type',
            value: 'Proprietorship',
          ),
          const InfoRow(
            icon: Icons.map_outlined,
            label: 'State',
            value: 'Karnataka',
          ),
          const InfoRow(
            icon: Icons.verified_outlined,
            label: 'FSSAI License',
            value: '11223344000122',
          ),
          const InfoRow(
            icon: Icons.attach_money_outlined,
            label: 'Currency',
            value: 'INR (₹)',
          ),
          const InfoRow(
            icon: Icons.event_outlined,
            label: 'Financial Year Start',
            value: '1st April',
          ),
        ],
      ),
    );
  }
}