import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrcodeflutter/home/controller/home_controller.dart';
import 'package:qrcodeflutter/mock/fruits_list_mock.dart';

class HomeFruitsScreen extends StatefulWidget {
  const HomeFruitsScreen({super.key});

  @override
  State<HomeFruitsScreen> createState() => _HomeFruitsScreenState();
}

class _HomeFruitsScreenState extends State<HomeFruitsScreen> {
  final HomeController homeController = HomeController();

  @override
  void initState() {
    super.initState();
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
            onPressed: () => homeController.abrirScanner(context),
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
                          homeController.selectedType = "contact";
                          homeController.qrData =
                              homeController.generateQRData();
                        });

                        homeController.mostrarQrDaFruta(
                            context, homeController.qrData, 'Contato');
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
                          homeController.selectedType = "url";
                          homeController.qrData =
                              homeController.generateQRData();
                        });

                        homeController.mostrarQrDaFruta(
                            context, homeController.qrData, 'Website');
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
                                homeController.mostrarQrDaFruta(
                                    context, qrData, fruta.nome);
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
