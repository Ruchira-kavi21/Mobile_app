import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/screens/bottom_nav.dart';
import 'package:real_state/screens/login.dart';
import 'package:real_state/providers/auth_provider.dart';
import 'package:real_state/providers/property_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.teal.shade600,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade600,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.token == null) {
            return Login();
          }
          return Bottomnav();
        },
      ),
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Bottomnav(),
      },
    );
  }
}
