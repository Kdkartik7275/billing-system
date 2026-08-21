import 'package:billing_system/features/billing/presentation/views/billing_page.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_mobile_body.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_tablet_body.dart';
import 'package:billing_system/features/dashboard/presentation/layout/dashboard_web_body.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_menu.dart';
import 'package:billing_system/features/inventory/presentation/views/inventory_page.dart';
import 'package:billing_system/features/settings/presentations/view/setting_page.dart';
import 'package:billing_system/features/suppliers/presentation/view/supplier_page.dart';
import 'package:flutter/material.dart';

Map<DashboardMenu, Widget> pages(int index) => {
  DashboardMenu.dashboard: index == 0
      ? MobileDashboardBody()
      : index == 1
      ? TabletDashboardBody()
      : DashboardWebBody(),
  DashboardMenu.pos: BillingPage(),
  DashboardMenu.inventory: InventoryPage(),
  DashboardMenu.sales: Center(child: Text('Sales')),
  DashboardMenu.customers: Center(child: Text('Customers')),
  DashboardMenu.employees: Center(child: Text('Employees')),
  DashboardMenu.suppliers: SupplierPage(),
  DashboardMenu.reports: Center(child: Text('Reports')),
  DashboardMenu.settings: SettingPage(),
};
