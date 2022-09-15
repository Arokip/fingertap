import 'package:flutter/material.dart';

class FingerTouch extends StatelessWidget {
  const FingerTouch({
    Key? key,
    required this.dx,
    required this.dy,
  }) : super(key: key);

  final double dx;
  final double dy;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx - 40,
      top: dy - 40,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}
