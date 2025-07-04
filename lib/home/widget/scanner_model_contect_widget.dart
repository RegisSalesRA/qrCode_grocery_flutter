
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerModalContentWidget extends StatefulWidget {
  final void Function(String) onDetect;

  const ScannerModalContentWidget({super.key, required this.onDetect});

  @override
  State<ScannerModalContentWidget> createState() => _ScannerModalContentWidgetState();
}

class _ScannerModalContentWidgetState extends State<ScannerModalContentWidget> {
  bool _alreadyDetected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Escaneie o QR Code", style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: MobileScanner(
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
          ),
        ],
      ),
    );
  }
}