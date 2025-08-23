import 'package:flutter/material.dart';
import 'link_checker_screen.dart';
import 'sms_checker_screen.dart';
import 'pdf_scanner_screen.dart';
import 'password_checker_screen.dart';
import 'wifi_checker_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      "title": "🔗 Link Checker",
      "screen": LinkCheckerScreen(),
      "color": Colors.blue
    },
    {
      "title": "📩 SMS Spam Checker",
      "screen": SmsCheckerScreen(),
      "color": Colors.orange
    },
    {
      "title": "📄 PDF Scanner",
      "screen": PdfScannerScreen(),
      "color": Colors.green
    },
    {
      "title": "🔐 Password Strength",
      "screen": PasswordCheckerScreen(),
      "color": Colors.purple
    },
    {
      "title": "📶 WiFi Security Checker",
      "screen": WifiCheckerScreen(),
      "color": Colors.red
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SecuroScan+')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: features.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final feature = features[index];
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: feature['color'],
                padding: EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => feature['screen']),
                );
              },
              child: Text(
                feature['title'],
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
