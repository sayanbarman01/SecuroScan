import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LinkCheckerScreen extends StatefulWidget {
  @override
  _LinkCheckerScreenState createState() => _LinkCheckerScreenState();
}

class _LinkCheckerScreenState extends State<LinkCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _checkLink() async {
    final url = _controller.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      // Get API key from api.env
      final apiKey = dotenv.env['API_KEY'];
      if (apiKey == null) throw 'API_KEY not found in api.env';

      // Submit link for scanning
      final submitResponse = await http.post(
        Uri.parse('https://example.com/submit'),
        body: {'url': url, 'key': apiKey},
      );

      if (submitResponse.statusCode != 200) {
        throw 'Submit failed: ${submitResponse.body}';
      }

      // Wait for scan to complete
      await Future.delayed(Duration(seconds: 10));

      // Check scan result
      final checkResponse = await http.get(
        Uri.parse('https://example.com/check?url=$url&key=$apiKey'),
      );

      if (checkResponse.statusCode == 200) {
        setState(() => _result = checkResponse.body);
      } else {
        throw 'Check failed: ${checkResponse.body}';
      }
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Link Checker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkLink,
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Check'),
            ),
            SizedBox(height: 24),
            Text(
              _result,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
