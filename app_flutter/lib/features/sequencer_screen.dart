import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_flutter/features/sample_editor.dart';
import 'package:app_flutter/features/pads_screen.dart';
import 'package:app_flutter/features/mixer_screen.dart';
import 'package:app_flutter/features/piano_roll.dart';
import 'package:app_flutter/features/settings_screen.dart';

class SequencerScreen extends StatefulWidget {
  const SequencerScreen({super.key});

  @override
  State<SequencerScreen> createState() => _SequencerScreenState();
}

class _SequencerScreenState extends State<SequencerScreen> {
  bool isPlaying = false;
  int currentStep = 0;
  double bpm = 120.0;
  
  // Сетка шагов: 4 трека (Kick, Snare, HH, Open HH) по 16 шагов
  List<List<bool>> grid = List.generate(4, (_) => List.generate(16, (_) => false));
  List<String> trackNames = ['KICK', 'SNARE', 'HI-HAT', 'OPEN-HH'];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // В реальном приложении здесь был бы вызов Rust через Stream или Timer
  }

  void _togglePlayback() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    // Имитация тика для UI (в реальности это делает Rust)
    final stepDuration = Duration(milliseconds: (60000 / bpm / 4).round());
    _timer = Timer.periodic(stepDuration, (timer) {
      setState(() {
        currentStep = (currentStep + 1) % 16;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('BOOMBAPDAP'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.apps, color: Colors.orangeAccent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PadsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.blueAccent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MixerScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.music_note, color: Colors.deepPurpleAccent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PianoRoll())),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          Center(child: Text('BPM: ${bpm.round()}  ')),
        ],
      ),
      body: Column(
        children: [
          // Панель управления
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 48, color: Colors.greenAccent),
                  onPressed: _togglePlayback,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Slider(
                    value: bpm,
                    min: 60,
                    max: 200,
                    onChanged: (value) {
                      setState(() {
                        bpm = value;
                        if (isPlaying) _startTimer();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Сетка секвенсора
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, trackIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SampleEditor(trackName: trackNames[trackIndex]),
                              ),
                            );
                          },
                          child: Text(
                            trackNames[trackIndex], 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(16, (stepIndex) {
                              bool isActive = grid[trackIndex][stepIndex];
                              bool isCurrent = currentStep == stepIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    grid[trackIndex][stepIndex] = !grid[trackIndex][stepIndex];
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: isActive 
                                        ? Colors.deepPurpleAccent 
                                        : (isCurrent ? Colors.white24 : Colors.white10),
                                    borderRadius: BorderRadius.circular(4),
                                    border: isCurrent ? Border.all(color: Colors.greenAccent, width: 2) : null,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
