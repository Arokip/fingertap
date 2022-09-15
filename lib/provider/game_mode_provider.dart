import 'package:fingertap/hive_constants.dart';
import 'package:flutter/material.dart';

enum GameMode { undecided, time20, taps20, noLimit, endless }

class GameModeProvider extends ChangeNotifier {
  GameMode mode = GameMode.undecided;

  void setGameMode(GameMode mode) {
    this.mode = mode;
    notifyListeners();
  }

  static String highScoreHiveString(GameMode mode) {
    switch (mode) {
      case GameMode.time20:
        return HiveConstants.highScoreTime20;
      case GameMode.taps20:
        return HiveConstants.highScore20Taps;
      case GameMode.noLimit:
        return HiveConstants.highScoreNoLimit;
      case GameMode.endless:
        return HiveConstants.highScoreEndless;
      case GameMode.undecided:
        return '';
    }
  }

  static String highScoreString(GameMode mode) {
    switch (mode) {
      case GameMode.time20:
        return 'Time 20';
      case GameMode.taps20:
        return '20 taps';
      case GameMode.noLimit:
        return 'No limit';
      case GameMode.endless:
        return 'Endless';
      case GameMode.undecided:
        return '';
    }
  }
}
