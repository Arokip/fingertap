import 'package:fingertap/provider/game_provider.dart';
import 'package:fingertap/widget/game_board.dart';
import 'package:fingertap/widget/game_end.dart';
import 'package:fingertap/widget/game_is_ready.dart';
import 'package:fingertap/widget/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreenContent extends StatelessWidget {
  const GameScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.select<GameProvider, GameState>((gameProvider) => gameProvider.gameState);
    switch (gameState) {
      case GameState.ready:
        return const GameIsReady();
      case GameState.running:
        return Column(
          children: [
            const TopBar(),
            Expanded(child: GameBoard(gameProvider: Provider.of<GameProvider>(context))),
          ],
        );
      case GameState.finished:
      case GameState.failed:
        return const GameEnd();
    }
  }
}
