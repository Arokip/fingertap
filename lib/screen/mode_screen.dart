import 'package:fingertap/hive_constants.dart';
import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/screen/game_screen.dart';
import 'package:fingertap/widget/back_button_aligned.dart';
import 'package:fingertap/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ModeScreen extends StatelessWidget {
  const ModeScreen({Key? key}) : super(key: key);

  void startGame(BuildContext context, GameMode mode) {
    Provider.of<GameModeProvider>(context, listen: false).setGameMode(mode);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final fingerCount = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.fingerCount);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        body: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset('assets/applifting_logo.svg', width: 400, color: Colors.grey[500]),
            const BackButtonAligned(light: true),
            Positioned(
              top: 96,
              child: Text('$fingerCount', style: const TextStyle(fontSize: 40, color: Colors.white)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                  onPressed: () => startGame(context, GameMode.time20),
                  text: GameModeProvider.highScoreString(GameMode.time20),
                ),
                MenuButton(
                  onPressed: () => startGame(context, GameMode.taps20),
                  text: GameModeProvider.highScoreString(GameMode.taps20),
                ),
                MenuButton(
                  onPressed: () => startGame(context, GameMode.noLimit),
                  text: GameModeProvider.highScoreString(GameMode.noLimit),
                ),
                const Gap(56),
                MenuButton(
                  onPressed: () => startGame(context, GameMode.endless),
                  text: GameModeProvider.highScoreString(GameMode.endless),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
