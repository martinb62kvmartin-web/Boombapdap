import 'package:flutter/material.dart';

class SampleEditor extends StatefulWidget {
  final String trackName;
  const SampleEditor({super.key, required this.trackName});

  @override
  State<SampleEditor> createState() => _SampleEditorState();
}

class _SampleEditorState extends State<SampleEditor> {
  double pitch = 1.0;
  double volume = 0.8;
  double stretch = 1.0;
  
  // ADSR Values
  double attack = 0.1;
  double decay = 0.2;
  double sustain = 0.7;
  double release = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text('Edit Sample: ${widget.trackName}'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waveform Placeholder
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepPurpleAccent),
              ),
              child: const Center(
                child: Icon(Icons.waves, color: Colors.deepPurpleAccent, size: 60),
              ),
            ),
            const SizedBox(height: 30),
            
            // Main Controls
            _buildSectionTitle('General Controls'),
            _buildSlider('Pitch', pitch, 0.5, 2.0, (v) => setState(() => pitch = v)),
            _buildSlider('Volume', volume, 0.0, 1.0, (v) => setState(() => volume = v)),
            _buildSlider('Stretch', stretch, 0.5, 4.0, (v) => setState(() => stretch = v)),
            
            const SizedBox(height: 30),
            
            // ADSR Controls
            _buildSectionTitle('ADSR Envelope'),
            _buildSlider('Attack', attack, 0.0, 2.0, (v) => setState(() => attack = v)),
            _buildSlider('Decay', decay, 0.0, 2.0, (v) => setState(() => decay = v)),
            _buildSlider('Sustain', sustain, 0.0, 1.0, (v) => setState(() => sustain = v)),
            _buildSlider('Release', release, 0.0, 5.0, (v) => setState(() => release = v)),
            
            const SizedBox(height: 30),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {}, // Normalize
                  icon: const Icon(Icons.align_vertical_center),
                  label: const Text('Normalize'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                ),
                ElevatedButton.icon(
                  onPressed: () {}, // Apply
                  icon: const Icon(Icons.check),
                  label: const Text('Apply Changes'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(color: Colors.white70))),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: Colors.deepPurpleAccent,
            onChanged: onChanged,
          ),
        ),
        Text(value.toStringAsFixed(2), style: const TextStyle(color: Colors.greenAccent)),
      ],
    );
  }
}
