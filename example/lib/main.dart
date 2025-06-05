import 'package:flutter/material.dart';
import 'package:qr_breeze/qr_breeze.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const QRBreezeExample(),
    );
  }
}

class QRBreezeExample extends StatefulWidget {
  /// Creates a [QRBreezeExample] widget.
  const QRBreezeExample({super.key});

  @override
  State<QRBreezeExample> createState() => _QRBreezeExampleState();
}

/// The state class for [QRBreezeExample], managing the scanned result and UI updates.
class _QRBreezeExampleState extends State<QRBreezeExample> {
  String? _scanResult; // Stores the result of the QR code scan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "QR Reader For You",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_scanResult != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Scanned Result: $_scanResult",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      /// Launches the [QRBreeze] scanner and captures the result.
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QRBreeze(
                            boxLineColor: Colors.blue,
                            title: 'Scan QR Code',
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _scanResult = result.toString();
                        });
                      }
                    },
                    child: const Text(
                      "Scan QR Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
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
}
