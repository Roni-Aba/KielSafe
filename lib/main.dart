import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const KielSafeApp());
}

class KielSafeApp extends StatelessWidget {
  const KielSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KielSafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}