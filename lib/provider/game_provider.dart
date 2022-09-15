import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fingertap/data/high_score.dart';
import 'package:fingertap/hive_constants.dart';
import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum GameState { ready, running, finished, failed }

enum TouchState { incrementing, decrementing, still }

class GameProvider with ChangeNotifier {
  GameProvider() {
    generateCount();
  }

  GameMode get mode => GameMode.undecided;

  GameState gameState = GameState.ready;

  TouchState touchState = TouchState.incrementing;
  int currentCount = 0;
  int previousCount = 0;
  Timer? gameTimer;
  int points = 0;

  num? highScoreCache;
  HighScoreItem? totalHighScoreCache;

  String get totalHighScoreString => totalHighScoreCache == null
      ? '-'
      : '${mode == GameMode.taps20 ? '${totalHighScoreCache!.score.toStringAsFixed(2)}s' : totalHighScoreCache!.score} (${totalHighScoreCache!.userName})';

  Future<num?> get highScore async {
    getTotalHighScore();
    final userName = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.userName);
    final docUser = FirebaseFirestore.instance.collection('users').doc(userName);
    final highScoreMap = ((await docUser.get()).data()?['highScore'][GameModeProvider.highScoreHiveString(mode)] ?? {});
    highScoreCache = highScoreMap['$maxFingerCount'];
    return highScoreMap['$maxFingerCount'];
  }

  Future<HighScoreItem?> getTotalHighScore() async {
    final highScoreFieldName = 'highScore.${GameModeProvider.highScoreHiveString(mode)}.$maxFingerCount';
    HighScoreItem? highScoreResult;
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy(highScoreFieldName, descending: mode != GameMode.taps20)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final name = documentSnapshot.get('name');
        final highScore = documentSnapshot.get(highScoreFieldName);
        highScoreResult = HighScoreItem(userName: name, score: highScore);
      }
    });
    totalHighScoreCache = highScoreResult;
    return highScoreResult;
  }

  int get maxFingerCount => Hive.box(HiveConstants.tapGameBox).get(HiveConstants.fingerCount) ?? 4;

  void startGameTimer() {}

  void disposeTimer() {
    gameTimer?.cancel();
    gameTimer = null;
  }

  void generateCount() {
    previousCount = currentCount;
    currentCount = math.Random().nextInt(maxFingerCount) + 1;
  }

  void saveHighScore(dynamic newHighScore) {
    final userName = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.userName);
    final docUser = FirebaseFirestore.instance.collection('users').doc(userName);
    docUser.get().then((value) {
      final currentHighScoreMap = value.data()?['highScore'][GameModeProvider.highScoreHiveString(mode)] ?? {};
      (currentHighScoreMap as Map<String, dynamic>).addAll({'$maxFingerCount': newHighScore});
      docUser.update({
        'highScore.${GameModeProvider.highScoreHiveString(mode)}': currentHighScoreMap,
      });
    });
  }

  void startGame() {
    gameState = GameState.running;
    startGameTimer();
    notifyListeners();
  }

  void winRound() {
    points++;
    generateCount();
    touchState = TouchState.incrementing;
    notifyListeners();
  }

  void failGame() {
    gameState = GameState.failed;
    disposeTimer();
    notifyListeners();
  }

  void finishGame() {
    gameState = GameState.finished;
    notifyListeners();
  }
}
