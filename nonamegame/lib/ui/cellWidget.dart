import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nonamegame/engine/engine.dart';
import 'package:nonamegame/main.dart';
import 'package:nonamegame/ui/crossPainter.dart';
import 'dart:io' show Platform;

class CellWidget extends StatefulWidget {

  final Moves _move;

  const CellWidget(this._move);
  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>  with SingleTickerProviderStateMixin{  
  double _fraction = 0.0;
  late Animation<double> _animation;
  late AnimationController controller;
  final double _size = isBig() ? 150 : 50; 

  void initState() {
    this.controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
        _animation = Tween(begin: 0.0, end: 1.0).animate(controller)
        ..addListener(() {
          setState(() {
            _fraction = _animation.value;
            });
        });
       controller.forward();
      super.initState();
  }


 @override
  Widget build(BuildContext context) 
    => Container(
      margin: EdgeInsets.all(5),
      height: _size,
      width: _size,
      decoration: BoxDecoration(
        color: Colors.blueGrey[300],
        borderRadius: BorderRadius.circular(5)
      ),
      child:
        Container(
          margin: EdgeInsets.all(isBig() ? 30 : 10),
          child:  CustomPaint(
            painter: 
              widget._move == Moves.EMPTY ?
              null : 
              CrossPainter(_fraction, widget._move == Moves.FIRST ? Colors.redAccent : Colors.greenAccent),
        )
      ),
    );
}