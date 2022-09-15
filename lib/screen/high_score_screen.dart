import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fingertap/data/high_score.dart';
import 'package:fingertap/hive_constants.dart';
import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/widget/high_score_list.dart';
import 'package:fingertap/widget/mode_selector.dart';
import 'package:fingertap/widget/number_selector.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({Key? key}) : super(key: key);

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  int selectedNumber = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.fingerCount) ?? 4;
  GameMode selectedMode = GameMode.time20;

  @override
  Widget build(BuildContext context) {
    Hive.box(HiveConstants.tapGameBox).get(HiveConstants.fingerCount);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: Colors.white, onPressed: () => Navigator.pop(context)),
                  const Text('High Scores', style: TextStyle(color: Colors.white, fontSize: 24)),
                  const Gap(40),
                ],
              ),
            ),
            Divider(color: Colors.grey[300]),
            NumberSelector(
              selectedNumber: selectedNumber,
              onChanged: (number) => setState(() => selectedNumber = number),
            ),
            Divider(color: Colors.grey[300]),
            ModeSelector(
              selectedMode: selectedMode,
              onChanged: (mode) => setState(() => selectedMode = mode),
            ),
            Divider(color: Colors.grey[300]),
            Expanded(
              child: FutureBuilder<List<HighScoreItem>>(
                future: getHighScoreTable(selectedNumber, selectedMode),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    final userName = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.userName);
                    return HighScoreList(
                      userName: userName,
                      highScore: snap.data ?? [],
                    );
                  }
                  return const Text('loading...', style: TextStyle(color: Colors.white));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<HighScoreItem>> getHighScoreTable(int number, GameMode mode) async {
    final highScoreFieldName = 'highScore.${GameModeProvider.highScoreHiveString(mode)}.$number';
    List<HighScoreItem> highScoreResult = [];
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy(highScoreFieldName, descending: mode != GameMode.taps20)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final name = documentSnapshot.get('name');
        final highScore = documentSnapshot.get(highScoreFieldName);
        highScoreResult.add(HighScoreItem(userName: name, score: highScore));
      }
    });
    return highScoreResult;
  }
}
