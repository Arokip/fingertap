import 'dart:io';

import 'package:fingertap/screen/high_score_screen.dart';
import 'package:fingertap/screen/mode_screen.dart';
import 'package:fingertap/screen/settings_screen.dart';
import 'package:fingertap/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/applifting_logo.svg',
              width: 400,
              colorFilter: ColorFilter.mode(
                Colors.grey[700]!,
                BlendMode.color,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ModeScreen())),
                  text: 'play',
                  fontSize: 24,
                ),
                const Gap(8),
                MenuButton(
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HighScoreScreen())),
                  text: 'high scores',
                ),
                MenuButton(
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                  text: 'settings',
                ),
                const Gap(24),
                MenuButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  text: 'EXIT',
                  fontSize: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
