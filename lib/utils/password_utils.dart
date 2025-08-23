import 'package:flutter/material.dart';

class PasswordUtils {
  static String checkStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$&*~^%()]'))) score++;

    if (password.length < 6) return "Very Weak";
    if (score <= 2) return "Weak";
    if (score == 3) return "Medium";
    if (score == 4) return "Strong";
    return "Very Strong";
  }

  static Color getStrengthColor(String level) {
    switch (level) {
      case "Very Weak":
        return Colors.red;
      case "Weak":
        return Colors.orange;
      case "Medium":
        return Colors.amber;
      case "Strong":
        return Colors.lightGreen;
      case "Very Strong":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
