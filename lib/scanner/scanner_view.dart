import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  final void Function(String) onDetect;

  const ScannerScreen({super.key, required this.onDetect});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _alreadyDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Escanear QR Code'),
        backgroundColor: Colors.white,
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          torchEnabled: true,
        ),
        onDetect: (capture) {
          if (_alreadyDetected) return;

          final code = capture.barcodes.first.rawValue;
          if (code != null) {
            _alreadyDetected = true;
            widget.onDetect(code);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
