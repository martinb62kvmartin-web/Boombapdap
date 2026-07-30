import 'package:flutter/material.dart';
import 'package:app_flutter/features/automation_editor.dart';

class MixerScreen extends StatefulWidget {
  const MixerScreen({super.key});

  @override
  State<MixerScreen> createState() => _MixerScreenState();
}

class _MixerScreenState extends State<MixerScreen> {
  List<double> volumes = List.generate(6, (_) => 0.8);
  double masterVolume = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('6-CHANNEL MIXER'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                bool isMaster = index == 5;
                return _buildChannelStrip(index, isMaster);
              },
            ),
          ),
          _buildEffectsPanel(),
        ],
      ),
    );
  }

  Widget _buildChannelStrip(int index, bool isMaster) {
    return Container(
      width: 100,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMaster ? Colors.blueGrey[900] : Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          InkWell(
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AutomationEditor(paramName: isMaster ? 'Master Volume' : 'CH ${index + 1} Volume'),
                ),
              );
            },
            child: Text(isMaster ? 'MASTER' : 'CH ${index + 1}', 
                 style: TextStyle(color: isMaster ? Colors.blueAccent : Colors.white, fontWeight: FontWeight.bold)),
          ),
          const Spacer(),
          // Fader
          Expanded(
            flex: 8,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: isMaster ? masterVolume : volumes[index],
                onChanged: (v) {
                  setState(() {
                    if (isMaster) {
                      masterVolume = v;
                    } else {
                      volumes[index] = v;
                    }
                  });
                },
                activeColor: isMaster ? Colors.blueAccent : Colors.greenAccent,
              ),
            ),
          ),
          const Spacer(),
          // Mute/Solo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSmallButton('S', Colors.yellow),
              _buildSmallButton('M', Colors.red),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String label, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(child: Text(label, style: TextStyle(color: color, fontSize: 12))),
    );
  }

  Widget _buildEffectsPanel() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEffectControl('COMP'),
          _buildEffectControl('REVERB'),
          _buildEffectControl('CRUSH'),
          _buildEffectControl('SATURN'),
        ],
      ),
    );
  }

  Widget _buildEffectControl(String name) {
    return Column(
      children: [
        const CircleAvatar(backgroundColor: Colors.deepPurple, radius: 20),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}
