import 'package:flutter/material.dart';
import 'package:nonamegame/engine/engine.dart';
import 'package:nonamegame/engine/field.dart';
import 'package:nonamegame/main.dart';
import 'package:nonamegame/ui/cellWidget.dart';

class FieldWidget extends StatefulWidget {
  final Field _field;

  FieldWidget(this._field);

  void markCell(int id)
    => _field.move(id, Moves.FIRST);

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<FieldWidget> {

  Widget getSmartCell(int index) => GestureDetector(
    child: CellWidget(widget._field.moves[index]),
    onTap: () {
      if(!widget._field.isFreeCell(index)) return;
      setState(() => widget._field.move(index, GameEngine().currentMove));
    },
  ); 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(isBig() ? 50 : 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              getSmartCell(0),
              getSmartCell(1),
          ],
          ), 
          Row(
            children: [
              getSmartCell(2),
              getSmartCell(3),
          ],
          ),
          Container(height: isBig()? 100 : 25,),
          Row(
            children: [
              getSmartCell(4),
              getSmartCell(5),
          ],
          ),
          Row(
            children: [
              getSmartCell(6),
              getSmartCell(7),
          ],
          ),
        ],
      ),
    );
  }
}

