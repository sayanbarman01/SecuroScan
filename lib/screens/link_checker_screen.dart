import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';



























class LinkCheckerScreen extends StatefulWidget {
  @override
  _LinkCheckerScreenState createState() => _LinkCheckerScreenState();
}

class _LinkCheckerScreenState extends State<LinkCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  // Get API key from .env
  final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  Future<void> _checkLink() async {
    final url = _controller.text.trim();
    if (url.isEmpty) {
      setState(() => _result = '⚠️ Please enter a URL.');
      return;
    }
    if (apiKey.isEmpty) {
      setState(() => _result = '⚠️ API key not found. Check your .env file.');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final endpoint =
          "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$apiKey";

      final requestBody = {
        "client": {"clientId": "securo-scan", "clientVersion": "1.0.0"},
        "threatInfo": {
          "threatTypes": [
            "MALWARE",
            "SOCIAL_ENGINEERING",
            "UNWANTED_SOFTWARE",
            "POTENTIALLY_HARMFUL_APPLICATION"
          ],
          "platformTypes": ["ANY_PLATFORM"],
          "threatEntryTypes": ["URL"],
          "threatEntries": [
            {"url": url}
          ]
        }
      };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['matches'] != null) {
          final threat = data['matches'][0];
          setState(() {
            _result =
                "🚨 Threat Found!\nType: ${threat['threatType']}\nPlatform: ${threat['platformType']}";
          });
        } else {
          setState(() => _result = "✅ This URL looks safe!");
        }
      } else {
        throw "API Error: ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      setState(() => _result = "❌ Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Safe Browsing - Link Checker")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter URL",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkLink,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text("Check"),
            ),
            SizedBox(height: 24),
            Text(
              _result,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
