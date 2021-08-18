import 'package:flutter/material.dart';
import 'package:vidiyal_login/constants.dart';

class LinkButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  LinkButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        title,
        style: TextStyle(
          letterSpacing: 1,
          color: LogoBlue,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
