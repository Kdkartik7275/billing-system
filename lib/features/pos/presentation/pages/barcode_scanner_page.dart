import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/pos/data/models/scan_entry.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:billing_system/features/pos/presentation/widgets/barcode/scan_feedback.dart';
import 'package:billing_system/features/pos/presentation/widgets/barcode/scan_head.dart';
import 'package:billing_system/features/pos/presentation/widgets/barcode/scanner_corner.dart';
import 'package:billing_system/features/pos/presentation/widgets/barcode/scanner_overlay_painter.dart';
import 'package:billing_system/features/pos/presentation/widgets/barcode/session_log_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _scannerController;
  late final AnimationController _lineController;
  late final Animation<double> _lineAnimation;

  final CartController _cart = Get.find<CartController>();

  bool _torchOn = false;
  bool _processing = false;

  final RxList<ScanEntry> _sessionLog = <ScanEntry>[].obs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      
    );

    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _scannerController.dispose();
    _lineController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_processing) {
      return;
    }

    final raw = capture.barcodes.firstOrNull?.rawValue;
    

    if (raw == null || raw.trim().isEmpty) {
      return;
    }

    setState(() => _processing = true);

    HapticFeedback.mediumImpact();

    _cart.onBarcodeScanned(raw);

    final existing = _sessionLog.firstWhereOrNull((e) => e.barcode == raw);

    if (existing == null) {
      final product = _cart.cartItems
          .firstWhereOrNull(
            (i) => i.product.barcode == raw || i.product.id == raw,
          )
          ?.product;

      _sessionLog.insert(
        0,
        ScanEntry(
          barcode: raw,
          productName: product?.name,
          productId: product?.id,
          success: product != null,
          time: TimeOfDay.now(),
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _processing = false);
      }
    });
  }

  void _close() {
    _cart.closeScanner();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            ScannerTopBar(
              torchOn: _torchOn,
              onTorchToggle: () {
                _scannerController.toggleTorch();
                setState(() => _torchOn = !_torchOn);
              },
              onClose: _close,
            ),
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _scannerController,
                    onDetect: _onDetect,
                  ),
                  CustomPaint(painter: ScannerOverlayPainter()),
                  AnimatedBuilder(
                    animation: _lineAnimation,
                    builder: (_, __) => Align(
                      alignment: Alignment(
                        0,
                        -0.12 + _lineAnimation.value * 0.24,
                      ),
                      child: Container(
                        height: 2.5,
                        width: 230,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withValues(alpha: 0.95),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const ScannerCorners(),
                  if (_processing)
                    Container(color: Colors.white.withValues(alpha: 0.06)),
                  Obx(() {
                    final msg = _cart.scanFeedbackMessage.value;
                    if (msg.isEmpty) return const SizedBox.shrink();
                    return Positioned(
                      top: 20,
                      left: 24,
                      right: 24,
                      child: ScanFeedbackToast(
                        message: msg,
                        success: _cart.scanSuccess.value,
                      ),
                    );
                  }),
                  const Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Text(
                      'Align barcode or QR code within the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: SessionLogPanel(sessionLog: _sessionLog, onDone: _close),
            ),
          ],
        ),
      ),
    );
  }
}
