import 'package:fingertap/data/high_score.dart';
import 'package:fingertap/widget/high_score_list_item.dart';
import 'package:flutter/material.dart';

class HighScoreList extends StatelessWidget {
  const HighScoreList({
    Key? key,
    required this.userName,
    required this.highScore,
  }) : super(key: key);

  final String userName;
  final List<HighScoreItem> highScore;

  @override
  Widget build(BuildContext context) {
    if (highScore.isEmpty) return const Text('No high score for this mode.', style: TextStyle(color: Colors.white));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        // shrinkWrap: true,
        itemCount: highScore.length,
        itemBuilder: (BuildContext context, int index) {
          final playerName = highScore[index].userName;
          return HighScoreListItem(
            index: index,
            isMe: playerName == userName,
            playerName: playerName,
            score: highScore[index].score,
          );
        },
      ),
    );
  }
}
