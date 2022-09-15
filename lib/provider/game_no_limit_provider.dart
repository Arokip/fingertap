import 'dart:async';

import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/provider/game_provider.dart';

class GameNoLimitProvider extends GameProvider {
  double _gameTime = 0;

  @override
  GameMode get mode => GameMode.noLimit;

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
    saveHighScore(points);
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
    super.finishGame();
  }

  @override
  void dispose() {
    disposeTimer();
    super.dispose();
  }
}
