import 'package:flutter/material.dart';
import 'link_checker_screen.dart';
import 'sms_checker_screen.dart';
/*import 'pdf_scanner_screen.dart';*/
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
      /*"screen": PdfScannerScreen(),*/
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
        child: ListView(
          children: [
            // ✅ Note Section
            Card(
              color: Colors.yellow[100],
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "📌 Note:\nThis app helps you check links, PDFs, SMS, and WiFi networks for safety.\n\n"
                  "PDF Checker is Upcoming Update , Many updates are coming soon, stay update stay secure\n"
                  "⚠️ Use it responsibly and always double-check suspicious content.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            SizedBox(height: 20),

            // ✅ Feature Buttons
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
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
                  ),
                )),
             // ✅ Note Section
            Card(
              color: const Color.fromARGB(173, 22, 67, 130),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "© SecuroScan+ || SB",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
