import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.title, required this.color, required this.onPressed});

  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
