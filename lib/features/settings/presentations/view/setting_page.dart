import 'package:billing_system/core/config/responsive/adaptive_layout.dart';
import 'package:billing_system/features/settings/presentations/layout/setting_mobile_layout.dart';
import 'package:billing_system/features/settings/presentations/layout/setting_tablet_layout.dart';
import 'package:billing_system/features/settings/presentations/layout/setting_web_layout.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobile: SettingMobileLayout(),
      tablet: SettingTabletLayout(),
      desktop: SettingWebLayout(),
    );
  }
}
