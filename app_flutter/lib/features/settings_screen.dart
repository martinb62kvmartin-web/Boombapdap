import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double exportSampleRate = 44100;
  int resamplingPoints = 256;
  String selectedBackground = 'Classic Studio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('SETTINGS & EXPORT'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('EXPORT SETTINGS'),
          _buildDropdown('Sample Rate', exportSampleRate.toString(), ['44100', '48000', '96000'], (v) {
            setState(() => exportSampleRate = double.parse(v!));
          }),
          _buildSlider('Resampling Points', resamplingPoints.toDouble(), 64, 512, (v) {
            setState(() => resamplingPoints = v.round());
          }),
          const SizedBox(height: 30),
          
          _buildSection('APPEARANCE'),
          _buildDropdown('Background', selectedBackground, ['Classic Studio', 'SP-404 Retro', 'Modern Dark', 'Neon Night'], (v) {
            setState(() => selectedBackground = v!);
          }),
          const SizedBox(height: 30),
          
          _buildSection('MIDI'),
          ListTile(
            title: const Text('MIDI Controller', style: TextStyle(color: Colors.white)),
            subtitle: const Text('No device connected', style: TextStyle(color: Colors.white54)),
            trailing: ElevatedButton(onPressed: () {}, child: const Text('Scan')),
          ),
          const SizedBox(height: 40),
          
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('EXPORT PROJECT TO WAV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        DropdownButton<String>(
          value: value,
          dropdownColor: Colors.black,
          style: const TextStyle(color: Colors.orangeAccent),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text(value.round().toString(), style: const TextStyle(color: Colors.orangeAccent)),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged, activeColor: Colors.orangeAccent),
      ],
    );
  }
}
