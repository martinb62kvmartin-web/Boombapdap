import 'package:flutter/material.dart';

class NoteData {
  int key;
  int startStep;
  int durationSteps;
  double velocity;

  NoteData({required this.key, required this.startStep, this.durationSteps = 1, this.velocity = 0.8});
}

class PianoRoll extends StatefulWidget {
  const PianoRoll({super.key});

  @override
  State<PianoRoll> createState() => _PianoRollState();
}

class _PianoRollState extends State<PianoRoll> {
  final double keyWidth = 60;
  final double noteHeight = 25;
  final double stepWidth = 40;
  final int totalNotes = 36; 
  final int totalSteps = 32;

  List<NoteData> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('PIANO ROLL'),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: [
          _buildPianoKeys(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalSteps * stepWidth,
                child: Stack(
                  children: [
                    _buildGrid(),
                    ...notes.map((note) => _buildNoteWidget(note)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPianoKeys() {
    return SizedBox(
      width: keyWidth,
      child: ListView.builder(
        reverse: true,
        itemCount: totalNotes,
        itemBuilder: (context, index) {
          int noteInOctave = index % 12;
          bool isBlack = [1, 3, 6, 8, 10].contains(noteInOctave);
          return Container(
            height: noteHeight,
            decoration: BoxDecoration(
              color: isBlack ? Colors.black : Colors.white,
              border: Border.all(color: Colors.grey[800]!, width: 0.5),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(isBlack ? '' : _getNoteName(index), 
                         style: TextStyle(color: isBlack ? Colors.white54 : Colors.black, fontSize: 10)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    return ListView.builder(
      reverse: true,
      itemCount: totalNotes,
      itemBuilder: (context, noteIndex) {
        return Container(
          height: noteHeight,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
          child: Row(
            children: List.generate(totalSteps, (stepIndex) {
              return GestureDetector(
                onTap: () => _addNote(noteIndex, stepIndex),
                child: Container(
                  width: stepWidth,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: stepIndex % 4 == 0 ? Colors.white24 : Colors.white10)),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildNoteWidget(NoteData note) {
    return Positioned(
      left: note.startStep * stepWidth,
      bottom: note.key * noteHeight,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            note.startStep += (details.delta.dx / stepWidth).round();
            if (note.startStep < 0) note.startStep = 0;
          });
        },
        onLongPress: () => setState(() => notes.remove(note)),
        child: Container(
          width: note.durationSteps * stepWidth,
          height: noteHeight,
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white54),
          ),
          child: const Center(child: Icon(Icons.drag_handle, size: 12, color: Colors.white54)),
        ),
      ),
    );
  }

  void _addNote(int key, int step) {
    setState(() {
      notes.add(NoteData(key: key, startStep: step));
    });
  }

  String _getNoteName(int index) {
    List<String> names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    return '${names[index % 12]}${(index / 12).floor() + 2}';
  }
}
