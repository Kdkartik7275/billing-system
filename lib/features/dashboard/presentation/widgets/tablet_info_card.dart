import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabletSmartPosCard extends StatelessWidget {
  const TabletSmartPosCard({super.key, this.branchName = 'Main Branch'});
  final String branchName;

  @override
  Widget build(BuildContext context) {
    final billsController = Get.find<BillingController>();
    final now = DateTime.now();
    final dateStr = "${now.day} ${_month(now.month)}, ${now.year}";
    final timeStr = TimeOfDay.fromDateTime(now).format(context);
    final shop = Get.find<UserController>().shop.value;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F6FE4), Color(0xFF1E4FC4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E4FC4).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
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
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          branchName,
                          style: const TextStyle(
                            color: Color(0xFFFFC857),
                            fontSize: 13,
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              children: [
                _InfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Today',
                  value: dateStr, 
                ),
                const SizedBox(width: 40),
                Container(
                  width: 1,
                  height: 34,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                const SizedBox(width: 40),
                _InfoTile(
                  icon: Icons.access_time_rounded,
                  label: 'Current Time',
                  value: timeStr,
                ),
                const Spacer(),
                if (billsController.pending.isNotEmpty)
                  _SyncButton(billsController: billsController),
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

class _SyncButton extends StatelessWidget {
  const _SyncButton({required this.billsController});
  final BillingController billsController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pending = billsController.pending.length;
      final syncing = billsController.syncing.value;
      final idle = pending == 0 && !syncing;

      final Color fg = idle
          ? const Color(0xFF16A34A)
          : (syncing ? const Color(0xFF2F6FE4) : const Color(0xFFEA580C));

      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: syncing ? null : () => billsController.syncBills(),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: fg.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: syncing
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(fg),
                          ),
                        )
                      : Icon(
                          idle
                              ? Icons.check_rounded
                              : Icons.sync_problem_rounded,
                          size: 15,
                          color: fg,
                        ),
                ),
                const SizedBox(width: 9),
                Text(
                  syncing ? 'Syncing…' : (idle ? 'Synced' : '$pending pending'),
                  style: TextStyle(
                    color: fg,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      );
    });
  }
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 15),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
