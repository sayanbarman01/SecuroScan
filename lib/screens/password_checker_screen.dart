import 'package:flutter/material.dart';
import '../utils/password_utils.dart'; // Password logic ke liye

class PasswordCheckerScreen extends StatefulWidget {
  @override
  _PasswordCheckerScreenState createState() => _PasswordCheckerScreenState();
}

class _PasswordCheckerScreenState extends State<PasswordCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _strength = '';
  Color _strengthColor = Colors.grey;

  void _checkStrength(String password) {
    final level = PasswordUtils.checkStrength(password);
    final color = PasswordUtils.getStrengthColor(level);

    setState(() {
      _strength = level;
      _strengthColor = color;
    });
  }

  double _getStrengthValue(String strength) {
    switch (strength) {
      case "Very Weak":
        return 0.2;
      case "Weak":
        return 0.4;
      case "Medium":
        return 0.6;
      case "Strong":
        return 0.8;
      case "Very Strong":
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password Strength Checker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: true,
              onChanged: _checkStrength,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            if (_strength.isNotEmpty) ...[
              Text(
                'Strength: $_strength',
                style: TextStyle(fontSize: 18, color: _strengthColor),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: _getStrengthValue(_strength),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                minHeight: 10,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
