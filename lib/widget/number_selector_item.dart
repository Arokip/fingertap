import 'package:flutter/material.dart';

class NumberSelectorItem extends StatelessWidget {
  const NumberSelectorItem({
    Key? key,
    required this.number,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final int number;
  final bool isSelected;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.grey[300] : Colors.grey[600],
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => onTap?.call(number),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text('$number', style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
