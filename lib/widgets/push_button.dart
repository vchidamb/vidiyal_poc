import 'package:flutter/material.dart';
import 'package:vidiyal_login/constants.dart';

class PushButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  PushButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Material(
        elevation: 5,
        color: LogoBlue,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
