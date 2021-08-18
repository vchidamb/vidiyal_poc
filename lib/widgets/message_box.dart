import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final String title, content;

  MessageBox({
    this.title = '',
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
