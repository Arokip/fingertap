import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HighScoreListItem extends StatelessWidget {
  const HighScoreListItem({
    Key? key,
    required this.index,
    this.isMe = false,
    required this.playerName,
    required this.score,
    this.isDouble = false,
  }) : super(key: key);

  final int index;
  final bool isMe;
  final String playerName;
  final num score;
  final bool isDouble;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isMe ? Colors.amber[400] : (index.isEven ? Colors.grey[500] : Colors.grey[400]),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Gap(8),
              Text('${index + 1}'),
              const Gap(12),
              Text(playerName),
              const Spacer(),
              (score is double) ? Text('${score.toStringAsFixed(2)} s') : Text('$score'),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}
