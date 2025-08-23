import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final Future<void> _loadEnv = dotenv.load(fileName: ".env");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadEnv,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'SecuroScan+',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.indigo),
            home: SplashScreen(),
          );
        } else if (snapshot.hasError) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: Text('Error loading .env: ${snapshot.error}')),
    ),
  );
}
         else {
          // Loading screen while env loads
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
