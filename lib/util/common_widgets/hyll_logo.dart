import 'package:flutter/material.dart';

class HyllLogo extends StatelessWidget {
  const HyllLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "HYLL",
      textDirection: TextDirection.ltr,
      style: TextStyle(
        color: Colors.black,
        fontSize: 28,
        letterSpacing: 1.5,
      ),
    );
  }
}