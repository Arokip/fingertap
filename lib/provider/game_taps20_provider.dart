import 'dart:async';

import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/provider/game_provider.dart';

class GameTaps20Provider extends GameProvider {
  double _gameTime = 0;

  @override
  GameMode get mode => GameMode.taps20;

  double get gameTime => _gameTime;

  @override
  void startGameTimer() {
    gameTimer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer timer) {
        _gameTime += 0.01;
        notifyListeners();
      },
    );
  }

  @override
  void winRound() {
    super.winRound();
    if (points >= 20) {
      finishGame();
    }
  }

  @override
  void saveHighScore(dynamic newHighScore) {
    highScore.then((highScoreValue) {
      if (newHighScore < (highScoreValue ?? double.infinity)) {
        super.saveHighScore(newHighScore);
      }
    });
  }

  @override
  void failGame() {
    disposeTimer();
    super.failGame();
  }

  @override
  void finishGame() {
    disposeTimer();
    saveHighScore(gameTime);
    super.finishGame();
  }

  @override
  void dispose() {
    disposeTimer();
    super.dispose();
  }
}
