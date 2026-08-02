import 'package:flutter/material.dart';

class AutomationPoint {
  Offset position;
  double curve; // 0 for linear, positive/negative for power curves

  AutomationPoint(this.position, {this.curve = 0.0});
}

class AutomationEditor extends StatefulWidget {
  final String paramName;
  const AutomationEditor({super.key, required this.paramName});

  @override
  State<AutomationEditor> createState() => _AutomationEditorState();
}

class _AutomationEditorState extends State<AutomationEditor> {
  List<AutomationPoint> points = [
    AutomationPoint(const Offset(0.1, 0.8)),
    AutomationPoint(const Offset(0.9, 0.2)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text('Automation: ${widget.paramName}'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() => points = [])),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapDown: (details) {
                      final localPos = details.localPosition;
                      setState(() {
                        points.add(AutomationPoint(Offset(
                          localPos.dx / constraints.maxWidth,
                          localPos.dy / constraints.maxHeight,
                        )));
                        points.sort((a, b) => a.position.dx.compareTo(b.position.dx));
                      });
                    },
                    child: CustomPaint(
                      painter: AutomationPainter(points),
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Tap to add points. Drag points to move (logic to be added).', 
                       style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class AutomationPainter extends CustomPainter {
  final List<AutomationPoint> points;

  AutomationPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (points.isEmpty) return;

    final path = Path();
    path.moveTo(points[0].position.dx * size.width, points[0].position.dy * size.height);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i].position;
      final p2 = points[i+1].position;
      
      // Simple linear path for now, curve logic can be added with cubicTo
      path.lineTo(p2.dx * size.width, p2.dy * size.height);
    }

    canvas.drawPath(path, paint);

    for (var p in points) {
      canvas.drawCircle(Offset(p.position.dx * size.width, p.position.dy * size.height), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
