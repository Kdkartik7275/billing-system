import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SalesQrScannerPage extends StatefulWidget {
  const SalesQrScannerPage({super.key});

  @override
  State<SalesQrScannerPage> createState() => _SalesQrScannerPageState();
}

class _SalesQrScannerPageState extends State<SalesQrScannerPage> {
  late final MobileScannerController scannerController;

  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();

    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      detectionTimeoutMs: 500,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;

      if (value == null || value.isEmpty) {
        continue;
      }

      _hasScanned = true;

      Navigator.of(context).pop(value);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Bill'),
        actions: [
          IconButton(
            onPressed: () {
              scannerController.toggleTorch();
            },
            icon: const Icon(Icons.flash_on_rounded),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: scannerController, onDetect: _onDetect),

          // Scanner overlay
          Center(
            child: Container(
              width: 320,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 60,
            child: Column(
              children: [
                const Text(
                  'Scan the QR code on the bill',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Place the QR code inside the frame',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
