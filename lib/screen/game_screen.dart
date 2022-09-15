import 'package:fingertap/provider/game_endless_provider.dart';
import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/provider/game_no_limit_provider.dart';
import 'package:fingertap/provider/game_provider.dart';
import 'package:fingertap/provider/game_taps20_provider.dart';
import 'package:fingertap/provider/game_time20_provider.dart';
import 'package:fingertap/screen/game_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mode = Provider.of<GameModeProvider>(context, listen: false).mode;
    return ChangeNotifierProvider<GameProvider>(
      create: (BuildContext context) {
        switch (mode) {
          case GameMode.undecided:
            throw Exception('game mode undecided');
          case GameMode.time20:
            return GameTime20Provider();
          case GameMode.taps20:
            return GameTaps20Provider();
          case GameMode.noLimit:
            return GameNoLimitProvider();
          case GameMode.endless:
            return GameEndlessProvider();
        }
      },
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey[400]!,
              body: const GameScreenContent(),
            ),
          ),
        );
      },
    );
  }
}
