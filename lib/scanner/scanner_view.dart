import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcodeflutter/scanner/controller/scanner_controller.dart';

class ScannerScreen extends StatefulWidget {
  final void Function(String) onDetect;
  const ScannerScreen({super.key, required this.onDetect});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ScannerController scannerController = ScannerController();

  @override
  void initState() {
    super.initState();
    scannerController.checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    if (!scannerController.hasPermission) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Scanner"),
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 350,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Permissão da câmera é necessária",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              scannerController.checkPermission();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Conceder permissão"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Escanear QR Code"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                scannerController.isFlashOn = !scannerController.isFlashOn;
                scannerController.scannerController.toggleTorch();
              });
            },
            icon: Icon(
                scannerController.isFlashOn ? Icons.flash_on : Icons.flash_off),
          )
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController.scannerController,
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              if (barcode.rawValue != null) {
                final String code = barcode.rawValue!;
                scannerController.processScannerData(code, widget.onDetect);
              }
            },
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Aponte o QR Code para a câmera",
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black.withAlpha(60),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
