import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:get/get.dart';

class DashboardShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardShellController>(() => DashboardShellController());
  }
}