import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'box_painter.dart';

class QRBreeze extends StatefulWidget {
  final Color? boxLineColor; // Custom color for scan box
  final String? title; // Custom title for AppBar
  const QRBreeze({super.key, this.boxLineColor, this.title = 'Scan QR Code'});

  @override
  _QRBreezeState createState() => _QRBreezeState();
}

class _QRBreezeState extends State<QRBreeze>
    with SingleTickerProviderStateMixin {
  String? _scannedData;
  bool _isPermissionGranted = false;
  bool _isTorchOn = false;
  late AnimationController _animationController;
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {}); // Trigger repaint on animation tick
      });
    _animationController.repeat(reverse: true);
  }

  // Camera permission check
  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      _showPermissionDeniedDialog(
        'Camera',
        'Camera permission is required to scan QR codes.',
      );
    }
  }

  // Gallery image scan
  Future<void> _pickAndScanImage() async {
    final photoStatus = await Permission.photos.request();
    if (!mounted) return; // Check if widget is still mounted
    if (photoStatus.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (!mounted) return; // Check again after picking image
      if (image == null) return;

      try {
        final result = await _controller.analyzeImage(image.path);
        if (!mounted) return; // Check after analyzing image
        if (result != null && result.barcodes.isNotEmpty) {
          setState(() {
            _scannedData = result.barcodes.first.rawValue ?? 'No data';
          });
          Navigator.pop(context, _scannedData); // Return scanned data
        } else {
          setState(() {
            _scannedData = 'No QR code found in the image';
          });
          Navigator.pop(context, _scannedData); // Return error message
        }
      } catch (e) {
        if (!mounted) return; // Check before showing SnackBar
        setState(() {
          _scannedData = 'Error scanning image: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.pop(context, _scannedData); // Return error message
      }
    } else {
      if (!mounted) return; // Check before showing dialog
      _showPermissionDeniedDialog(
        'Photos',
        'Photo library permission is required to scan QR codes from images. Please enable it in Settings under "Photos" or "Storage".',
      );
    }
  }

  // Permission denied dialog with glassmorphism
  void _showPermissionDeniedDialog(String permissionName, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        // backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$permissionName Permission Denied',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        // backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.black54,
                            width: .6,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        // style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        // backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.black54,
                            width: .6,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await openAppSettings();
                      },
                      child: const Text('App Settings'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [Colors.blueAccent, Colors.purpleAccent],
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //     ),
      //   ),
      //   title: const Text(
      //     'QR Code Scanner',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 22,
      //     ),
      //   ),
      //   actions: [],
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final qrScanSize = constraints.maxWidth * 0.8;
          return Stack(
            children: [
              // Camera preview
              _isPermissionGranted
                  ? MobileScanner(
                      controller: _controller,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final barcode = barcodes.first;
                          setState(() {
                            _scannedData = barcode.rawValue ?? 'No data';
                          });
                          _controller.stop();
                          Navigator.pop(context, _scannedData);
                        }
                      },
                    )
                  : const Center(
                      child: Text(
                        'Camera permission not granted',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
              // Custom scan box
              Positioned(
                left: (constraints.maxWidth - qrScanSize) / 2,
                top: (constraints.maxHeight - qrScanSize) * 0.333333,
                child: CustomPaint(
                  painter: QrScanBoxPainter(
                    boxLineColor: Colors.white,
                    animationValue: _animationController.value,
                  ),
                  child: SizedBox(width: qrScanSize, height: qrScanSize),
                ),
              ),
              // Help text
              Positioned(
                top: (constraints.maxHeight - qrScanSize) * 0.333333 +
                    qrScanSize +
                    16,
                width: constraints.maxWidth,
                child: Center(
                  child: Text(
                    widget.title ?? 'Scan QR Code',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (constraints.maxHeight - qrScanSize) * 0.433333 +
                    qrScanSize +
                    16,
                width: constraints.maxWidth,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      await _controller.toggleTorch();
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.boxLineColor ??
                            Colors.white.withOpacity(0.4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: _isTorchOn
                          ? Image.asset(
                              color: widget.boxLineColor ?? Colors.redAccent,
                              width: 35,
                              height: 35,
                              fit: BoxFit.fill,
                              'assets/images/tool_flashlight_open.png',
                            )
                          : Image.asset(
                              width: 35,
                              height: 35,
                              'assets/images/tool_flashlight_close.png',
                            ),
                      // Icon(
                      //   _isTorchOn ? Icons.flash_on : Icons.flash_off,
                      //   color: Colors.white,
                      //   size: 28,
                      // ),
                    ),
                  ),
                ),
              ),
              // Scanned data display with slide-in animation
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                bottom: _scannedData != null ? 100 : -100,
                width: constraints.maxWidth,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      _scannedData ?? 'Scan a QR code or pick an image',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Buttons
              Positioned(
                bottom: 20,
                width: constraints.maxWidth,
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.grey.withOpacity(0.7),
                  //   // borderRadius: BorderRadius.circular(12),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black.withOpacity(0.3),
                  //       blurRadius: 10,
                  //       spreadRadius: 2,
                  //     ),
                  //   ],
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedButton(
                        text: 'Reset',
                        icon: Icons.refresh,
                        onPressed: () {
                          setState(() {
                            _scannedData = null;
                          });
                          _controller.start();
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildAnimatedButton(
                        text: ' Gallery',
                        icon: Icons.photo_library_outlined,
                        onPressed: _pickAndScanImage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Animated button widget
  Widget _buildAnimatedButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(onPressed == null ? 0.95 : 1.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   colors: [Colors.blueAccent, Colors.purpleAccent],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
