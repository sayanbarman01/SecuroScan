import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PdfScannerScreen extends StatefulWidget {
  @override
  _PdfScannerScreenState createState() => _PdfScannerScreenState();
}

class _PdfScannerScreenState extends State<PdfScannerScreen> {
  String _result = '';
  String? _fileName;
  bool _loading = false;

  Future<void> _pickAndScanPdf() async {
    setState(() {
      _result = '';
      _fileName = null;
      _loading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: kIsWeb, // Web ke liye bytes chahiye
      );

      if (result != null) {
        final apiKey = dotenv.env['API_KEY'];
        if (apiKey == null) throw 'API_KEY not found in .env';

        if (kIsWeb) {
          // Web
          Uint8List fileBytes = result.files.first.bytes!;
          String base64File = base64Encode(fileBytes);
          _fileName = result.files.first.name;

          final response = await http.post(
            Uri.parse('https://example.com/scan-pdf'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'key': apiKey,
              'file': base64File,
              'name': _fileName,
            }),
          );

          if (response.statusCode == 200) {
            setState(() => _result = response.body);
          } else {
            setState(() => _result = 'Scan failed: ${response.body}');
          }
        } else {
          // Mobile
          File file = File(result.files.single.path!);
          _fileName = file.path.split('/').last;

          final request = http.MultipartRequest(
            'POST',
            Uri.parse('https://example.com/scan-pdf'),
          );
          request.fields['key'] = apiKey;
          request.files.add(await http.MultipartFile.fromPath('file', file.path));

          final response = await request.send();
          final responseBody = await response.stream.bytesToString();

          if (response.statusCode == 200) {
            setState(() => _result = responseBody);
          } else {
            setState(() => _result = 'Scan failed: $responseBody');
          }
        }
      } else {
        setState(() => _result = '❌ No file selected');
      }
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _pickAndScanPdf,
              child: Text('Select PDF and Scan'),
            ),
            SizedBox(height: 20),
            if (_fileName != null)
              Text("📄 Selected: $_fileName"),
            SizedBox(height: 20),
            if (_loading)
              CircularProgressIndicator(),
            if (_result.isNotEmpty)
              Text(
                _result,
                style: TextStyle(
                  fontSize: 16,
                  color: _result.toLowerCase().contains("safe")
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
