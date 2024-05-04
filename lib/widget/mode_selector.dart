import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/widget/mode_selector_item.dart';
import 'package:flutter/material.dart';

class ModeSelector extends StatefulWidget {
  const ModeSelector({
    super.key,
    required this.selectedMode,
    this.onChanged,
  });

  final GameMode selectedMode;
  final Function(GameMode)? onChanged;

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  late GameMode selectedMode;
  final modes = GameMode.values.sublist(1);

  @override
  void initState() {
    selectedMode = widget.selectedMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final mode in modes)
              ModeSelectorItem(
                mode: mode,
                isSelected: selectedMode == mode,
                onTap: (gameMode) {
                  widget.onChanged?.call(gameMode);
                  setState(() => selectedMode = gameMode);
                },
              ),
          ],
        ),
      ],
    );
  }
}
