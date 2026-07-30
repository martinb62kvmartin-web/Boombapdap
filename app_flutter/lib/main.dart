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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _engineStatus = "Waiting for Rust engine...";

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  Future<void> _initEngine() async {
    // После генерации кода здесь будет:
    // await RustLib.init();
    // final status = await initApp();
    // setState(() => _engineStatus = status);
    
    // Пока что имитируем задержку
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _engineStatus = "Rust Engine Bridge Configured (Run codegen to activate)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boombapdap Beatmaker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings_input_component, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              _engineStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Bridge: Flutter <-> Rust Core'),
          ],
        ),
      ),
    );
  }
}
