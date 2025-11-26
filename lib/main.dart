import 'package:flutter/material.dart';

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
      home: const KielSafeHomePage(),
    );
  }
}

class KielSafeHomePage extends StatelessWidget {
  const KielSafeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KielSafe'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_bike, size: 72),
              SizedBox(height: 24),
              Text(
                'Willkommen bei KielSafe 🚲',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Hier werden später Unfall-Hotspots in Kiel angezeigt.\n'
                    'Wenn du dich einem Hotspot näherst, soll dein Handy vibrieren.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}