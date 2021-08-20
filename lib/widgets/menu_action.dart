import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double padding;

  MenuAction({
    required this.icon,
    required this.onTap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: GestureDetector(
          onTap: onTap,
          child: FaIcon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
