import 'package:nonamegame/engine/engine.dart';

class Field {
  final int _fieldCode;
  final _updateGame;
  final List<Moves> _moves; 
  List<Moves> get moves => _moves;

  Field(this._fieldCode, this._updateGame) : _moves = List.filled(8, Moves.EMPTY);

  void move(int position, Moves move){
    if(position < 0 || position >= 8)
      throw Exception("position must be greater or equal than 0 and less than 8");
      _moves[position] = move;
      _updateGame(_fieldCode, position);
  }

  bool isFreeCell(int index) => _moves[index] == Moves.EMPTY;
  bool internalLeftMarked() => _moves[3] != Moves.EMPTY && _moves[5] != Moves.EMPTY;
  bool internalRightMarked() => _moves[2] != Moves.EMPTY && _moves[4] != Moves.EMPTY;
}