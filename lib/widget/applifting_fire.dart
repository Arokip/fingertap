import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppliftingFire extends StatelessWidget {
  const AppliftingFire({
    Key? key,
    this.location = 0,
    required this.count,
  }) : super(key: key);

  final double location;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 400 + location,
      left: 0,
      right: 0,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (int i = 0; i < count; i++)
              SvgPicture.asset(
                'assets/applifting_logo.svg',
                width: 80,
                height: 80,
              ),
          ],
        ),
      ),
    );
  }
}
