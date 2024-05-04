import 'package:fingertap/provider/game_endless_provider.dart';
import 'package:fingertap/provider/game_no_limit_provider.dart';
import 'package:fingertap/provider/game_provider.dart';
import 'package:fingertap/provider/game_taps20_provider.dart';
import 'package:fingertap/provider/game_time20_provider.dart';
import 'package:fingertap/widget/back_button_aligned.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class GameIsReady extends StatelessWidget {
  const GameIsReady({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return GestureDetector(
      onTap: gameProvider.startGame,
      child: Container(
        color: Colors.grey[400],
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BackButtonAligned(),
              const Gap(80),
              const Text('TAP TO START', style: TextStyle(fontSize: 40)),
              const Gap(80),
              Expanded(
                child: FutureBuilder(
                  future: gameProvider.highScore,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      final highScore = snap.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (gameProvider is GameTime20Provider && highScore != null)
                            Text('Your best score: $highScore', style: const TextStyle(fontSize: 18)),
                          if (gameProvider is GameTaps20Provider && highScore != null)
                            Text(
                              'Your best time: ${highScore.toStringAsFixed(2)}s',
                              style: const TextStyle(fontSize: 18),
                            ),
                          if (gameProvider is GameNoLimitProvider && highScore != null)
                            Text('Your best score: $highScore', style: const TextStyle(fontSize: 18)),
                          if (gameProvider is GameEndlessProvider && highScore != null)
                            Text('Your current score is: $highScore', style: const TextStyle(fontSize: 18)),
                          if (highScore == null) const Text('You have no high score recorded.'),
                          const Gap(16),
                          Text(
                            'High score to beat: ${gameProvider.totalHighScoreString}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Spacer(),
                        ],
                      );
                    }
                    return const Text('Loading highScore...');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
