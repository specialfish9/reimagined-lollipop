import 'package:flutter/material.dart';
import 'package:nonamegame/engine/engine.dart';
import 'package:nonamegame/engine/field.dart';
import 'package:nonamegame/ui/fieldSeparatorWidget.dart';
import 'package:nonamegame/ui/fieldWidget.dart';

class GamePage extends StatefulWidget {
  final GameEngine _engine;

  GamePage() : _engine = GameEngine();

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  //TODO: find a better way to do it beacause this sucks.
  Widget _fields;
  String _hintText;

  _GamePageState() : _fields = Container(), _hintText = "RED START";

  @override
  void initState() { 
    // Listen for updates from engine
    widget._engine.subscribeForFields().listen((newFileds) {
      setState(() {
          _fields = _createFields(newFileds);
      });
    });

    widget._engine.subscribeForEvents().listen(
      (event) 
        => setState((){
          if(event == GameEvents.FIRST_WIN)
            _hintText = "REF WON";
          else if(event == GameEvents.SECOND_WIN)
            _hintText = "GREEN WON";
          else if (event == GameEvents.FIRST_TURN)
            _hintText = "RED TURN";
          else if (event == GameEvents.SECOND_TURN)
            _hintText = "GREEN TURN";
        })
    );

    widget._engine.init();
    super.initState();
  }

  Widget _createFields(List<Field> fields)
    =>  ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fields.length,
                itemBuilder: (context, index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    index != 0 ?
                    FieldSeparator() : Container(), 
                    FieldWidget(fields[index])
                  ],
                ) 
              );
  void _onReplayPressed(){
    widget._engine.init();
  }

  @override
  Widget build(BuildContext context) 
    => Scaffold(
      body: Container(
        color: Colors.blueGrey[700],
        child: Column(
          children: [
            Row(
              children: [
                MaterialButton(
                  height: 70,
                  color: Colors.blueGrey,
                  minWidth: 200,
                  onPressed: _onReplayPressed,
                  child: Text("Play Again", style: TextStyle(fontSize: 25,),
                  )
                ),
               Container(
                  margin: EdgeInsets.only(top: 20, left: MediaQuery.of(context).size.width /2 - 300),
                  child: Text(_hintText,style: TextStyle(fontSize: 40),),
                ),
              ],
            ),
            Expanded(child: _fields),
           
          ],
        ),
      ),
    );
    
}