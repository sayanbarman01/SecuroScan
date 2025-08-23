import 'package:flutter/material.dart';

class SmsCheckerScreen extends StatefulWidget {
  @override
  _SmsCheckerScreenState createState() => _SmsCheckerScreenState();
}

class _SmsCheckerScreenState extends State<SmsCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _checkSms() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _loading = true;
      _result = '';
    });

    await Future.delayed(Duration(milliseconds: 600)); // Simulate brief processing delay

    final result = _detectSpam(message);

    setState(() {
      _result = result;
      _loading = false;
    });
  }

  String _detectSpam(String text) {
    final spamKeywords = [
      'win',
      'prize',
      'lottery',
      'free',
      'money',
      'urgent',
      'claim now',
      'click here',
      'congratulations',
      'offer',
      'reward',
      'selected',
      'cash',
      'bonus',
      'cheap',
      'investment',
      'act now',
    ];

    int score = 0;

    for (final word in spamKeywords) {
      if (text.toLowerCase().contains(word)) {
        score++;
      }
    }

    if (score >= 4) return "📛 Spam Detected (High confidence)";
    if (score >= 2) return "⚠️ Possibly Spam (Medium confidence)";
    return "✅ Looks Safe";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SMS Spam Checker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Paste SMS content here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _checkSms,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Check SMS'),
            ),
            SizedBox(height: 24),
            Text(
              _result,
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
