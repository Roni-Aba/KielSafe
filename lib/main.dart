import 'package:flutter/material.dart';

void main() {
  runApp(const kielsafeApp());
}

class kielsafeApp extends StatelessWidget {
  const kielsafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kielsafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const kielsafeHomePage(),
    );
  }
}

class kielsafeHomePage extends StatelessWidget {
  const kielsafeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('kielsafe'),
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
                'Willkommen bei kielsafe 🚲',
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