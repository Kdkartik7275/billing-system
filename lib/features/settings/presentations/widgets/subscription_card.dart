import 'package:billing_system/core/card/card_shell.dart';
import 'package:billing_system/features/settings/presentations/widgets/card_header.dart';
import 'package:billing_system/features/settings/presentations/widgets/info_row.dart';
import 'package:billing_system/features/settings/presentations/widgets/status_pill.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final VoidCallback? onViewPlan;
  const SubscriptionCard({super.key, this.onViewPlan});

  @override
  Widget build(BuildContext context) {
    return CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            icon: Icons.emoji_events_outlined,
            iconBg: const Color(0xFFE3F7E9),
            iconColor: const Color(0xFF1E9E4E),
            title: 'Subscription',
            trailing: InkWell(
              onTap: onViewPlan,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'View Plan',
                    style: TextStyle(
                      color: Color(0xFF1E9E4E),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 18, color: Color(0xFF1E9E4E)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const InfoRow(
            icon: Icons.badge_outlined,
            label: 'Current Plan',
            value: 'Premium',
          ),
          InfoRow(
            icon: Icons.event_available_outlined,
            label: 'Validity',
            valueWidget: Text(
              'Valid till 30 Jun 2026',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E9E4E),
              ),
            ),
          ),
          InfoRow(
            icon: Icons.info_outline,
            label: 'Status',
            valueWidget: const StatusPill(
              label: 'Active',
              bg: Color(0xFF1E9E4E),
              fg: Colors.white,
              icon: Icons.check_circle,
            ),
          ),
        ],
      ),
    );
  }
}
