import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

Center circularProgress(context) {
  return Center(
    child: SpinKitFadingCircle(size: 40.0, color: AppColors.primary),
  );
}
