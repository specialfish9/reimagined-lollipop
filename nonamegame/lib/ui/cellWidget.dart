import 'package:flutter/material.dart';
import 'package:nonamegame/engine/engine.dart';
import 'package:nonamegame/ui/crossPainter.dart';

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
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.blueGrey[300],
        borderRadius: BorderRadius.circular(5)
      ),
      child:
        Container(
          margin: EdgeInsets.all(30),
          child:  CustomPaint(
            painter: 
              widget._move == Moves.EMPTY ?
              null : 
              CrossPainter(_fraction, widget._move == Moves.FIRST ? Colors.redAccent : Colors.greenAccent),
        )
      ),
    );
}