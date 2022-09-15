import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:flutter/material.dart';

class ModeSelectorItem extends StatelessWidget {
  const ModeSelectorItem({
    Key? key,
    required this.mode,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final GameMode mode;
  final bool isSelected;
  final Function(GameMode)? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.grey[300] : Colors.grey[600],
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => onTap?.call(mode),
        child: SizedBox(
          width: 64,
          height: 40,
          child: Center(
            child: Text(
              GameModeProvider.highScoreString(mode),
              style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
