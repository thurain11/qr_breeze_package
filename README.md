# QRBreeze

A lightweight and customizable Flutter package for scanning QR codes and barcodes with a sleek, user-friendly interface. QRBreeze provides an easy-to-use widget for integrating QR code and barcode scanning into your Flutter applications, with support for camera scanning, gallery image scanning, and a customizable UI.

## Features

- **QR Code and Barcode Scanning**: Scan QR codes and barcodes using the device's camera with the `mobile_scanner` package.
- **Gallery Image Scanning**: Pick images from the gallery and extract QR code or barcode data.
- **Customizable UI**: Customize the scan box color and title text to match your app's theme.
- **Flashlight Support**: Toggle the flashlight for better scanning in low-light conditions.
- **Permission Handling**: Automatically handles camera and photo library permissions with user-friendly dialogs.
- **Animated Scan Box**: Includes a smooth animation for the scan box to enhance the user experience.
- **Cross-Platform**: Works on both Android and iOS devices.

## Installation

To use QRBreeze in your Flutter project, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  qr_breeze: ^0.0.1
```

Run the following command to fetch the package:

```bash
flutter pub get
```

## Usage

### Basic Example

To integrate QRBreeze into your app, simply add the `QRBreeze` widget to your widget tree. Below is a basic example:

```dart
import 'package:flutter/material.dart';
import 'package:qr_breeze/qr_breeze.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('QRBreeze Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Navigate to QRBreeze and get the scanned result
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QRBreeze(
                    boxLineColor: Colors.blue,
                    title: 'Scan QR Code',
                  ),
                ),
              );
              if (result != null) {
                print('Scanned: $result');
              }
            },
            child: const Text('Start Scanning'),
          ),
        ),
      ),
    );
  }
}
```


Then, declare them in your project's `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/tool_flashlight_open.png
    - assets/images/tool_flashlight_close.png
```

**Note**: If the package uses `packages/qr_breeze/` prefix for assets (as recommended), you don't need to copy these files to your project.


## Dependencies

QRBreeze relies on the following packages:
- `mobile_scanner: ^7.0.1` - For QR code and barcode scanning.
- `image_picker: ^1.1.2` - For picking images from the gallery.
- `permission_handler: 12.0.0+1` - For managing camera and photo permissions.

Ensure your project meets the requirements for these dependencies.

## Requirements

- **Flutter Version**: 3.16 or higher (uses `Color.withValues` instead of deprecated `Color.withOpacity`).
- **Platforms**: Android, iOS.
- **Permissions**: Camera and photo library permissions are required. QRBreeze handles permission requests automatically.

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue on the [GitHub repository](https://github.com/yourusername/qr_breeze). To contribute code:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a clear description of your changes.

## License

This package is licensed under the [MIT License](LICENSE). See the `LICENSE` file for details.

## Contact

For questions or support, please open an issue on the [GitHub repository](https://github.com/yourusername/qr_breeze) or contact the maintainer at [thurainhein097@gmail.com].

---

Happy scanning with QRBreeze! 🚀