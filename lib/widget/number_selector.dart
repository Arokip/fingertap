import 'package:fingertap/widget/number_selector_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NumberSelector extends StatefulWidget {
  const NumberSelector({
    super.key,
    required this.selectedNumber,
    this.onChanged,
  });

  final int selectedNumber;
  final Function(int)? onChanged;

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  late int selectedNumber;

  @override
  void initState() {
    selectedNumber = widget.selectedNumber;
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
            for (int i = 1; i <= 5; i++)
              NumberSelectorItem(
                number: i,
                isSelected: i == selectedNumber,
                onTap: (number) {
                  widget.onChanged?.call(number);
                  setState(() => selectedNumber = number);
                },
              ),
          ],
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 6; i <= 10; i++)
              NumberSelectorItem(
                number: i,
                isSelected: i == selectedNumber,
                onTap: (number) {
                  widget.onChanged?.call(number);
                  setState(() => selectedNumber = number);
                },
              ),
          ],
        ),
      ],
    );
  }
}
