import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/features/inventory/presentation/layout/inventory_desktop_layout.dart';
import 'package:billing_system/features/inventory/presentation/layout/inventory_mobile_layout.dart';
import 'package:billing_system/features/inventory/presentation/layout/inventory_tablet_layout.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobile: InventoryMobileLayout(),
      tablet: InventoryTabletLayout(),
      desktop: InventoryDesktopLayout(),
    );
  }
}
