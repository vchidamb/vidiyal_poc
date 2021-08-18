import 'package:flutter/material.dart';
import 'package:vidiyal_login/constants.dart';

class LoginTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextEditingController? textEditingController;
  final void Function(String?)? onSaved;

  LoginTextFormField({
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textEditingController,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
        decoration: kTextFieldDecoration.copyWith(hintText: hintText),
        controller: textEditingController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return hintText + ' is required.';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
