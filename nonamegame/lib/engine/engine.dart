import 'dart:async';

import 'package:nonamegame/engine/field.dart';

enum Moves { FIRST, SECOND, EMPTY}
enum GameEvents {FIRST_WIN, SECOND_WIN, FIRST_TURN, SECOND_TURN}

class GameEngine {
  static GameEngine _instance = GameEngine._internal();
  final List<Field> _fields;
  final StreamController<List<Field>> _fieldsController;
  final StreamController<GameEvents> _eventsController;
  bool _isFirstTurn;

  bool get isFirstTurn => _isFirstTurn;
  Moves get currentMove => _isFirstTurn ? Moves.FIRST : Moves.SECOND;
  
  factory GameEngine() => _instance;

  GameEngine._internal()
   : _fields = [],
    _isFirstTurn = true,
    _fieldsController = StreamController.broadcast() ,
    _eventsController = StreamController.broadcast();

  Stream<List<Field>> subscribeForFields()
    => _fieldsController.stream;

  Stream<GameEvents> subscribeForEvents()
    => _eventsController.stream;

  void init(){
    _isFirstTurn = true;
    _fields.clear();
    _fields.add(Field(0, _onMoveDone));
    _fields.add(Field(1, _onMoveDone));
    _fieldsController.add(_fields);
    print("[ENGINE] GameEngine init: Done");
  }

  List<Field> _lastFields()  => [_fields[_fields.length - 2], _fields.last];

  bool shouldOpen()
    => _lastFields()[0].internalLeftMarked() && _lastFields()[1].internalRightMarked();

  void open()
    => _fields.add(Field(_fields.length, _onMoveDone));

  void _onMoveDone(int fieldIndex, int position){
    bool someoneHasWin = _checkWin(currentMove);
    if(someoneHasWin){
        _eventsController.add(currentMove == Moves.FIRST ? GameEvents.FIRST_WIN : GameEvents.SECOND_WIN);
        return;
    }
    
   
    if(shouldOpen()){
      open();
      print("[ENGINE] New field opened");
    } else {
       _isFirstTurn = !_isFirstTurn;
    }
    // Update the ui
    _eventsController.add(_isFirstTurn? GameEvents.FIRST_TURN : GameEvents.SECOND_TURN);
    _fieldsController.add(_fields);
  }

  // TODO: Make this method smarter
  bool _checkWin(Moves player){
    var win = false;

    for(var i = 0, j = 1; j < _fields.length; i++, j++){
      var first = _fields[i];
      var second = _fields[j];

      // check horizontal    
      for(var k = 0; k < 8; k+=2){
        win = win || _areFromSamePlayer([first.moves[0 + k], first.moves[1+k], second.moves[0+k], second.moves[1+k]], player);
      }

      // check oblique
      win = win || _areFromSamePlayer([first.moves[0], first.moves[3], second.moves[4], second.moves[7]], player);
      win = win || _areFromSamePlayer([first.moves[6], first.moves[5], second.moves[2], second.moves[1]], player);

      if(win) return true;
    }

    // check vertical
    for(Field f in _fields){
      for(var k = 0; k < 2; k++)
        win = win || _areFromSamePlayer([f.moves[0+k], f.moves[2+k], f.moves[4+k], f.moves[6+k]], player);
      if(win)
        return true;
    }

    // Looks for forks
    if(_fields.length > 2){
      for(var i = 0, j = 1, k = 2; k < _fields.length; i++, j++,k++){
        var f = _fields[i], s = _fields[j], t = _fields[k];
        for(var n = 0; n < 8; n+=2){
          win = win || _areFromSamePlayer([f.moves[1+n],s.moves[0+n], s.moves[1+n], t.moves[0+n] ], player);
        }
      }
      print("[ENGINE] Found a fork");
      if(win)
        return true;
    }

    return false;
  }

  bool _areFromSamePlayer(List<Moves> moves, Moves player)
    => moves.fold(true, (previousValue, element) => previousValue && element == player);

}