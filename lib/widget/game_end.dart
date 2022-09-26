import 'package:fingertap/provider/game_endless_provider.dart';
import 'package:fingertap/provider/game_no_limit_provider.dart';
import 'package:fingertap/provider/game_provider.dart';
import 'package:fingertap/provider/game_taps20_provider.dart';
import 'package:fingertap/provider/game_time20_provider.dart';
import 'package:fingertap/screen/game_screen.dart';
import 'package:fingertap/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class GameEnd extends StatelessWidget {
  const GameEnd({Key? key}) : super(key: key);

  // TODO: rewrite to separate widgets by modes

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Container(
      color: Colors.grey,
      child: Center(
        child: FutureBuilder(
          future: gameProvider.highScore,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              final highScore = snap.data as num?;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (gameProvider.gameState == GameState.failed)
                    const Text(
                      'Whoops... you made a mistake!',
                      style: TextStyle(fontSize: 20),
                    ),
                  const Gap(16),
                  if (gameProvider is GameTime20Provider)
                    Column(
                      children: [
                        if (gameProvider.gameState == GameState.finished)
                          const Text('Time is up! Excellent, you withstood till the end.'),
                        const Gap(8),
                        Text('You collected ${gameProvider.points} points.'),
                        const Gap(8),
                        if (highScore != null) Text('Your high score is: $highScore.'),
                        const Gap(16),
                      ],
                    ),
                  if (gameProvider is GameTaps20Provider)
                    Column(
                      children: [
                        if (gameProvider.gameState == GameState.finished) ...[
                          const Text('Completed! You managed to tap everything correctly.'),
                          const Gap(8),
                          Text('It took you: ${gameProvider.gameTime.toStringAsFixed(2)} seconds.'),
                          const Gap(8),
                        ],
                        if (gameProvider.gameState == GameState.failed) ...[
                          Text('You failed at time: ${gameProvider.gameTime.toStringAsFixed(2)} seconds,'),
                          Text('and collected only ${gameProvider.points} points.'),
                          const Gap(8),
                        ],
                        if (highScore != null) Text('Your best time is: ${highScore.toStringAsFixed(2)}.'),
                        const Gap(16),
                      ],
                    ),
                  if (gameProvider is GameNoLimitProvider)
                    Column(
                      children: [
                        Text('You collected ${gameProvider.points} points.'),
                        const Gap(8),
                        if (highScore != null) Text('Your high score is: $highScore points.'),
                        const Gap(16),
                      ],
                    ),
                  if (gameProvider is GameEndlessProvider)
                    Column(
                      children: [
                        Text('You collected ${gameProvider.points} points.'),
                        const Gap(8),
                        if (highScore != null) Text('Your high score is: $highScore points.'),
                        const Gap(16),
                      ],
                    ),
                  Text('The high score is: ${gameProvider.totalHighScoreString}'),
                  const Gap(40),
                  MenuButton(
                    onPressed: () =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GameScreen())),
                    text: 'Play again',
                  ),
                  MenuButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'BACK',
                  ),
                ],
              );
            }
            return const Text('Loading high scores...');
          },
        ),
      ),
    );
  }
}
