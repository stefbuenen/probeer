import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ShaderDemo()));
}

class ShaderDemo extends StatefulWidget {
  const ShaderDemo({super.key});
  @override
  State<ShaderDemo> createState() => _ShaderDemoState();
}

class _ShaderDemoState extends State<ShaderDemo> with SingleTickerProviderStateMixin {
  ui.FragmentProgram? program;
  ui.FragmentShader? shader;

  @override
  void initState() {
    super.initState();
    loadShader();
  }

  Future<void> loadShader() async {
    program = await ui.FragmentProgram.fromAsset('assets/shaders/ripple.frag');
    setState(() {
      // shader will be created on paint, when we have size
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (program != null) {
          shader = program!.fragmentShader()
            ..setFloat(0, size.width)
            ..setFloat(1, size.height);
        }
        return CustomPaint(
          size: size,
          painter: _ShaderPainter(shader),
        );
      }),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  final ui.FragmentShader? shader;

  _ShaderPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    if (shader == null) return;
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
