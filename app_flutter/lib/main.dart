import 'package:flutter/material.dart';

void main() {
  runApp(const BoombapdapApp());
}

class BoombapdapApp extends StatelessWidget {
  const BoombapdapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boombapdap',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boombapdap Beatmaker'),
      ),
      body: const Center(
        child: Text('Welcome to Boombapdap! Ready to drop some beats?'),
      ),
    );
  }
}
