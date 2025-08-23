import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  // Ensure Flutter engine bindings are initialized before async work
  WidgetsFlutterBinding.ensureInitialized();

  // Load env file once
  await dotenv.load(fileName: "api.env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecuroScan+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SplashScreen(),
    );
  }
}
