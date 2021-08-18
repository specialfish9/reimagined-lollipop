import 'package:flutter/material.dart';
import 'package:nonamegame/ui/crossPainter.dart';

class FieldSeparator extends StatelessWidget {
  const FieldSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: CustomPaint(
        painter: CrossPainter(1, Colors.black),
      ),
    );
  }
}