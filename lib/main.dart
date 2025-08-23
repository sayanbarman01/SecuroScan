import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(SecuroScanApp());
}

class SecuroScanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecuroScan+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SplashScreen(), // Launch splash first
    );
  }
}
