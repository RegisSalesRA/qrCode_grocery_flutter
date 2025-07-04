import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QR Code Flutter",
      theme: ThemeData(
          primaryColor: Colors.green,
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.greenAccent,
            brightness: Brightness.light,
          )),
      home: HomeFruitsScreen(),
    );
  }
}
