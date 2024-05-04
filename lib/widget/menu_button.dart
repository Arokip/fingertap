import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.fontSize = 20,
  });

  final VoidCallback onPressed;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
      child: Text(text.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: fontSize)),
    );
  }
}
