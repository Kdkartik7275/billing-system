import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProductDetailTabBar extends StatelessWidget {
  final TabController controller;

  const ProductDetailTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        padding: EdgeInsets.zero,
        controller: controller,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        labelStyle: Theme.of(context).textTheme.titleSmall,
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Stock History'),
          Tab(text: 'Analytics'),
        ],
      ),
    );
  }
}
