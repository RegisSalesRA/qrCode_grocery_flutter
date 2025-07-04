import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcodeflutter/home/widget/scanner_model_contect_widget.dart';
import 'package:qrcodeflutter/mock/fruits_list_mock.dart';

class HomeFruitsScreen extends StatefulWidget {
  const HomeFruitsScreen({super.key});

  @override
  State<HomeFruitsScreen> createState() => _HomeFruitsScreenState();
}

class _HomeFruitsScreenState extends State<HomeFruitsScreen> {
  String qrData = '';
  String selectedType = 'contact';

  final TextEditingController _textController = TextEditingController();

  void _mostrarQrDaFruta(String qrData, String frutaNome) {
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
            TextButton(
              child: Text("Fechar"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void _marcarFrutaComoLida(String jsonScaneado) {
    try {
      final data = jsonDecode(jsonScaneado);
      final nome = data['nome'];

      final index = frutas.indexWhere((f) => f.nome == nome);
      if (index != -1) {
        setState(() {
          frutas[index].lida = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${frutas[index].nome} marcada como lida!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Fruta não encontrada')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar QR Code')),
      );
    }
  }

  void _abrirScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ScannerModalContentWidget(onDetect: _marcarFrutaComoLida);
      },
    );
  }

  String _generateQRData() {
    switch (selectedType) {
      case 'contact':
        return '''BEGIN:VCARD
              VERSION: 3.0
              FN: "Grocery Flutter Qrcode"
              TEL: "(85) 9 9999 9999"
              EMAIL: "email@gmail.com"
              END:VCARD''';

      case 'url':
        String url = 'https://flutter.dev/';
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = 'https://$url';
        }
        return url;

      default:
        return _textController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Frutas com QR Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: _abrirScanner,
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.contact_page_outlined),
                      label: Text("Contact"),
                      onPressed: () {
                        setState(() {
                          selectedType = "contact";
                          qrData = _generateQRData();
                        });

                        _mostrarQrDaFruta(qrData, 'Contato');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.web),
                      label: Text("Website"),
                      onPressed: () {
                        setState(() {
                          selectedType = "url";
                          qrData = _generateQRData();
                        });

                        _mostrarQrDaFruta(qrData, 'Website');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: frutas.length,
                itemBuilder: (context, index) {
                  final fruta = frutas[index];
                  return Card(
                    color: fruta.lida ? Colors.green.shade100 : null,
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: ListTile(
                      leading: Image.asset(fruta.imagem, width: 50, height: 50),
                      title: Text(fruta.nome),
                      subtitle: Text('R\$ ${fruta.preco.toStringAsFixed(2)}'),
                      trailing: fruta.lida
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : GestureDetector(
                              onTap: () {
                                final qrData = jsonEncode(fruta.toJson());
                                _mostrarQrDaFruta(qrData, fruta.nome);
                              },
                              child: Icon(Icons.qr_code, color: Colors.grey),
                            ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
