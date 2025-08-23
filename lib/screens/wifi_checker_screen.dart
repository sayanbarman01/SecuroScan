import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WifiCheckerScreen extends StatefulWidget {
  @override
  _WifiCheckerScreenState createState() => _WifiCheckerScreenState();
}

class _WifiCheckerScreenState extends State<WifiCheckerScreen> {
  String _wifiName = '';
  String _bssid = '';
  String _ip = '';
  String _securityStatus = '';
  bool _loading = false;

  Future<void> _checkWifi() async {
    setState(() => _loading = true);

    final info = NetworkInfo();

    final wifiName = await info.getWifiName();
    final bssid = await info.getWifiBSSID();
    final ip = await info.getWifiIP();

    String security = "🔒 Secured";
    if (wifiName != null &&
        (wifiName.toLowerCase().contains("open") ||
         wifiName.toLowerCase().contains("free") ||
         wifiName.toLowerCase().contains("public"))) {
      security = "⚠️ Possibly Insecure (Open WiFi)";
    }

    setState(() {
      _wifiName = wifiName ?? "Unknown";
      _bssid = bssid ?? "Unknown";
      _ip = ip ?? "Unknown";
      _securityStatus = security;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkWifi(); // Automatically check on load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WiFi Checker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📡 WiFi Name (SSID): $_wifiName"),
                  SizedBox(height: 8),
                  Text("🧭 BSSID (Router MAC): $_bssid"),
                  SizedBox(height: 8),
                  Text("🌐 IP Address: $_ip"),
                  SizedBox(height: 16),
                  Text("🔐 Security Status: $_securityStatus",
                      style: TextStyle(
                          fontSize: 16,
                          color: _securityStatus.contains("⚠️")
                              ? Colors.red
                              : Colors.green)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkWifi,
                    child: Text('Refresh Info'),
                  )
                ],
              ),
      ),
    );
  }
}
