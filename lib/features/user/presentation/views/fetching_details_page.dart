import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FetchingDetailsPage extends StatefulWidget {
  const FetchingDetailsPage({super.key, required this.userId, this.onDone});

  final String userId;
  final VoidCallback? onDone;

  @override
  State<FetchingDetailsPage> createState() => _FetchingDetailsPageState();
}

class _FetchingDetailsPageState extends State<FetchingDetailsPage>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _dotsController;
  late final UserController _controller;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _controller = Get.put<UserController>(
      UserController(
        getUserByIdUseCase: sl(),
        getShopByIdUseCase: sl(),
        shopFirebaseService: sl(),
        logoutUsecase: sl(),
        biometricService: sl()
      ),
    );

    _runFetch();
  }

  Future<void> _runFetch() async {
    final success = await _controller.fetchAccountDetails(
      userId: widget.userId,
    );
    if (success) {
      await Future.delayed(const Duration(milliseconds: 500));
      widget.onDone?.call();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  AppColors.primary.withOpacity(0.08),
                  AppColors.background,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Obx(
                () => _controller.errorMessage.value != null
                    ? _ErrorState(
                        message: _controller.errorMessage.value!,
                        onRetry: _runFetch,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _OrbitingLogo(pulseController: _pulseController),
                          const SizedBox(height: 36),
                          Text(
                            _controller.statusMessage.value,
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "Just a moment while we get everything in place.",
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.black45,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _BouncingDots(controller: _dotsController),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: AppColors.error,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Couldn\'t load your details',
            style: textTheme.titleLarge?.copyWith(color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(color: Colors.black45),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: Colors.white,
              ),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Brand mark that gently breathes in size, ringed by a spinning
/// indeterminate arc — reads as "actively working", not just decorative.
class _OrbitingLogo extends StatelessWidget {
  const _OrbitingLogo({required this.pulseController});
  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    return SizedBox(
      height: 108,
      width: 108,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 108,
            width: 108,
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary.withOpacity(0.35),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: scale,
            builder: (context, child) =>
                Transform.scale(scale: scale.value, child: child),
            child: Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.point_of_sale_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three dots that bounce in a staggered wave while data loads.
class _BouncingDots extends StatelessWidget {
  const _BouncingDots({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = ((controller.value - delay) % 1.0 + 1.0) % 1.0;
            final bounce = t < 0.5
                ? Curves.easeOut.transform(t / 0.5)
                : 1 - Curves.easeIn.transform((t - 0.5) / 0.5);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.translate(
                offset: Offset(0, -8 * bounce),
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.5 + 0.5 * bounce),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
