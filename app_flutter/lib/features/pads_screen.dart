import 'package:flutter/material.dart';

class PadsScreen extends StatefulWidget {
  const PadsScreen({super.key});

  @override
  State<PadsScreen> createState() => _PadsScreenState();
}

class _PadsScreenState extends State<PadsScreen> {
  // Состояние загруженных сэмплов на пэды
  List<String?> padSamples = List.generate(16, (_) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('SP-404 STYLE PADS'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'DRAG & DROP SAMPLES HERE',
              style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                return _buildPad(index);
              },
            ),
          ),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildPad(int index) {
    bool hasSample = padSamples[index] != null;
    return GestureDetector(
      onTapDown: (_) {
        // Здесь будет вызов Rust: trigger_sample(index)
      },
      child: DragTarget<String>(
        onAccept: (data) {
          setState(() {
            padSamples[index] = data;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              color: hasSample ? Colors.orange.withOpacity(0.8) : Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: hasSample ? Colors.orangeAccent.withOpacity(0.5) : Colors.black,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
              border: Border.all(
                color: candidateData.isNotEmpty ? Colors.white : Colors.orangeAccent.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: hasSample ? Colors.black : Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (hasSample)
                    const Icon(Icons.audiotrack, size: 16, color: Colors.black),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildKnob('REMAIN'),
          _buildKnob('DEL'),
          _buildKnob('REC'),
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.red,
            child: Text('EXT\nSOURCE', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildKnob(String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[700]!, width: 2),
            gradient: const LinearGradient(colors: [Colors.grey, Colors.black], begin: Alignment.topLeft),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}
