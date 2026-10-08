import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const CargoFlowApp());
}

class CargoFlowApp extends StatelessWidget {
  const CargoFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CargoFlow Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF0284C7),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}