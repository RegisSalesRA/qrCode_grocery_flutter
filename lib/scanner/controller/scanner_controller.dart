import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerController {
  bool hasPermission = false;
  bool isFlashOn = false;

  final MobileScannerController scannerController =
      MobileScannerController(torchEnabled: false);

  Future<void> checkPermission() async {
    final status = await Permission.camera.request();
    hasPermission = status.isGranted;
  }

  void processScannerData(String code, void Function(String) onDetect) {
    onDetect(code);
  }
}
