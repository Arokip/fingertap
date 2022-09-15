import 'package:fingertap/provider/game_no_limit_provider.dart';
import 'package:fingertap/provider/game_provider.dart';
import 'package:fingertap/provider/game_taps20_provider.dart';
import 'package:fingertap/provider/game_time20_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBarTimer extends StatelessWidget {
  const TopBarTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    if (gameProvider is GameTime20Provider) {
      return Text(
        gameProvider.gameTime.toStringAsFixed(2),
        style: TextStyle(fontSize: 32, color: gameProvider.gameTime > 3 ? Colors.black : Colors.red),
      );
    }
    if (gameProvider is GameTaps20Provider) {
      return SizedBox(
        width: gameProvider.gameTime.floor().toStringAsFixed(0).length * 18 + 56,
        child: Text(
          gameProvider.gameTime.toStringAsFixed(2),
          style: const TextStyle(fontSize: 32),
        ),
      );
    }
    if (gameProvider is GameNoLimitProvider) {
      return SizedBox(
        width: gameProvider.gameTime.floor().toStringAsFixed(0).length * 18 + 56,
        child: Text(
          gameProvider.gameTime.toStringAsFixed(2),
          style: const TextStyle(fontSize: 32),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
