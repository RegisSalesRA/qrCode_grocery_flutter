import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcodeflutter/mock/fruits_list_mock.dart';
import 'package:qrcodeflutter/scanner/scanner_view.dart';
import 'package:share_plus/share_plus.dart';

class HomeController {
  String qrData = '';
  String selectedType = 'contact';

  final TextEditingController _textController = TextEditingController();

  void mostrarQrDaFruta(BuildContext context, String qrData, String frutaNome) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('QR Code de $frutaNome'),
          content: SizedBox(
            width: 250,
            height: 250,
            child: Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 45,
                  child: OutlinedButton.icon(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        Share.share(qrData);
                      },
                      label: Text("Share")),
                ),
                TextButton(
                  child: Text("Fechar"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void marcarFrutaComoLida(String jsonScaneado) {
    try {
      final data = jsonDecode(jsonScaneado);
      final nome = data['nome'];

      final index = frutas.indexWhere((f) => f.nome == nome);
      if (index != -1) {
        frutas[index].lida = true;
      }
    } catch (e) {
      e;
    }
  }

  void abrirScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScannerScreen(onDetect: marcarFrutaComoLida),
      ),
    );
  }

  String generateQRData() {
    switch (selectedType) {
      case 'contact':
        return '''
BEGIN:VCARD
VERSION:3.0
FN:Grocery Flutter Qrcode
TEL;TYPE=CELL:(85)9999-9999
EMAIL:email@gmail.com
END:VCARD
''';

      case 'url':
        return 'https://flutter.dev';

      default:
        return _textController.text;
    }
  }
}
