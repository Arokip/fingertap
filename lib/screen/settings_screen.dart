import 'package:fingertap/hive_constants.dart';
import 'package:fingertap/screen/finger_count_screen.dart';
import 'package:fingertap/screen/new_user_screen.dart';
import 'package:fingertap/widget/back_button_aligned.dart';
import 'package:fingertap/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final fingerCount = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.fingerCount);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        body: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/applifting_logo.svg',
              width: 400,
              colorFilter: ColorFilter.mode(
                Colors.grey[500]!,
                BlendMode.color,
              ),
            ),
            const BackButtonAligned(light: true),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                MenuButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FingerCountScreen()))
                        .then((value) => setState(() {}));
                  },
                  text: 'max ${fingerCount ?? '-'} ${fingerCount == 1 ? 'finger' : 'fingers'}',
                ),
                MenuButton(
                  onPressed: () {
                    final userName = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.userName);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewUserScreen(username: userName)));
                  },
                  text: 'change username',
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
