import 'dart:ui';
import 'package:flutter/material.dart';

import '../main.dart';

class CrossPainter extends CustomPainter {
  final Paint _paint;
  final double _fraction;
 
  CrossPainter(this._fraction, Color color) :_paint = Paint() {
    _paint
      ..color = color
      ..strokeWidth = isBig() ? 10.0 : 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }
 
  @override
  void paint(Canvas canvas, Size size) {
    
    double leftLineFraction, rightLineFraction;
 
    // first the left adn then the right
    if (_fraction < .5) {
      leftLineFraction = _fraction / .5;
      rightLineFraction = 0.0;
    } else {
      leftLineFraction = 1.0;
      rightLineFraction = (_fraction - .5 ) /.5;
    }
 
    canvas.drawLine(Offset(0.0, 0.0),
        Offset(size.width * leftLineFraction, size.height * leftLineFraction), _paint);
 
    if (_fraction >= .5) {
      canvas.drawLine(Offset(size.width, 0.0),
              Offset(size.width - size.width * rightLineFraction, size.height * rightLineFraction), _paint);
    }
  }
 
  @override
  bool shouldRepaint(CrossPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}