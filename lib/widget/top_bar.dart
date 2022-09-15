import 'package:fingertap/provider/game_endless_provider.dart';
import 'package:fingertap/provider/game_no_limit_provider.dart';
import 'package:fingertap/provider/game_provider.dart';
import 'package:fingertap/provider/game_taps20_provider.dart';
import 'package:fingertap/provider/game_time20_provider.dart';
import 'package:fingertap/widget/menu_button.dart';
import 'package:fingertap/widget/top_bar_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => openPauseDialog(context, gameProvider),
          padding: const EdgeInsets.only(left: 16),
          icon: const Icon(Icons.pause),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (gameProvider is! GameTaps20Provider)
                      Text('Score: ${gameProvider.points}', style: const TextStyle(fontSize: 22)),
                    if (gameProvider is GameTaps20Provider)
                      Text('${20 - gameProvider.points} taps remaining', style: const TextStyle(fontSize: 22)),
                    if (gameProvider is GameTime20Provider) ...[
                      Text('Your high score: ${gameProvider.highScoreCache ?? '-'}'),
                      Text('High score: ${gameProvider.totalHighScoreString}'),
                    ],
                    if (gameProvider is GameTaps20Provider) ...[
                      Text('Your high score: ${gameProvider.highScoreCache?.toStringAsFixed(2) ?? '-'}'),
                      Text('High score: ${gameProvider.totalHighScoreString}'),
                    ],
                    if (gameProvider is GameNoLimitProvider) ...[
                      Text('Your high score: ${gameProvider.highScoreCache ?? '-'}'),
                      Text('High score: ${gameProvider.totalHighScoreString}'),
                    ],
                    if (gameProvider is GameEndlessProvider) ...[
                      Text('High score: ${gameProvider.totalHighScoreString}'),
                    ],
                  ],
                ),
                const Spacer(),
                const TopBarTimer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void openPauseDialog(BuildContext context, GameProvider gameProvider) {
  gameProvider.disposeTimer();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text('Quit the game?'),
        actions: [
          MenuButton(
            onPressed: () {
              gameProvider.startGameTimer();
              Navigator.pop(context);
            },
            text: 'Continue',
          ),
          MenuButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: 'Quit',
          ),
        ],
      );
    },
  );
}
