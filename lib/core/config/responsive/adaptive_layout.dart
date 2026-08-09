import 'package:billing_system/core/config/responsive/responsive_extension.dart';
import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop;
    }

    if (context.isTablet) {
      return tablet;
    }

    return mobile;
  }
}
