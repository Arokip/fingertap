import 'package:flutter/material.dart';

class BackButtonAligned extends StatelessWidget {
  const BackButtonAligned({
    super.key,
    this.light = false,
  });

  final bool light;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BackButton(
          color: light ? Colors.white : Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
