import 'package:flutter/material.dart';
import 'package:sisyphus/utils/app_routes.dart';

import 'screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sisyhus Cryto trading',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode, // Enable system-based light/dark mode
      initialRoute: AppRoutes.tradingDashboard, // Set the initial route
      routes: {
        AppRoutes.tradingDashboard: (context) => HomePage(),
        // Add routes for other screens
      },
    );
  }
}

// Light theme
final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFFFFFFF),
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
    backgroundColor: Colors.white,
    textTheme: TextTheme(headline1: TextStyle(color: Colors.black)));

// Dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF17181B),
  appBarTheme: AppBarTheme(backgroundColor: Color(0xFF17181B)),
  backgroundColor: Color(0xFF17181B),
);
