import 'dart:async';

import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/provider/game_provider.dart';

class GameTime20Provider extends GameProvider {
  double _gameTime = 20;

  @override
  GameMode get mode => GameMode.time20;

  double get gameTime => _gameTime;

  // @override
  // int? get highScore => tapGameBox.get(GameModeProvider.highScoreHiveString(mode));

  @override
  void startGameTimer() {
    gameTimer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer timer) {
        if (_gameTime <= 0) {
          disposeTimer();
          finishGame();
        } else {
          _gameTime -= 0.01;
          notifyListeners();
        }
      },
    );
  }

  @override
  void saveHighScore(dynamic newHighScore) {
    highScore.then((highScoreValue) {
      if (newHighScore > (highScoreValue ?? 0)) {
        super.saveHighScore(newHighScore);
      }
    });
  }

  @override
  void failGame() {
    disposeTimer();
    saveHighScore(points);
    super.failGame();
  }

  @override
  void finishGame() {
    disposeTimer();
    saveHighScore(points);
    super.finishGame();
  }

  @override
  void dispose() {
    disposeTimer();
    super.dispose();
  }
}
