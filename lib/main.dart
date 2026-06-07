import 'package:billing_system/app/app.dart';
import 'package:billing_system/app/bootstrap.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Bootstrap.initialize();

  runApp(const MyApp());
}
