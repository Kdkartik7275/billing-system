import 'package:billing_system/core/sync/widgets/sync_status_pill.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmartPosInfoCard extends StatelessWidget {
  const SmartPosInfoCard({super.key, this.branchName = 'Main Branch'});
  final String branchName;

  @override
  Widget build(BuildContext context) {
    final billsController = Get.find<BillingController>();
    final now = DateTime.now();
    final dateStr = "${now.day} ${_month(now.month)}, ${now.year}";
    final timeStr = TimeOfDay.fromDateTime(now).format(context);
    final shop = Get.find<UserController>().shop.value;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F6FE4), Color(0xFF1E4FC4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E4FC4).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop?.shopName ?? 'Smart POS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFFFFC857),
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          branchName,
                          style: const TextStyle(
                            color: Color(0xFFFFC857),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.calendar_today_rounded,
                        label: 'Today',
                        value: dateStr,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 34,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.access_time_rounded,
                        label: 'Current Time',
                        value: timeStr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (billsController.pending.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child:
                        SyncStatusPill(), // was: SyncButton(billsController: billsController)
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10.5,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
