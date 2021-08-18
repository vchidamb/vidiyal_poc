import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:vidiyal_login/widgets/push_button.dart';
import 'package:vidiyal_login/widgets/link_button.dart';
import 'package:vidiyal_login/widgets/login_textformfield.dart';
import 'package:vidiyal_login/widgets/message_box.dart';
import 'package:vidiyal_login/screens/login.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset_password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '';
  bool _showSpinner = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FocusManager.instance.primaryFocus!.unfocus();
      setState(() {
        _showSpinner = true;
      });

      try {
        await _auth.sendPasswordResetEmail(
          email: _email,
        );

        setState(() {
          _showSpinner = false;
        });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MessageBox(
                title: 'Password Reset',
                content:
                    'An email has been sent with link to reset the password.',
              );
            });
      } on FirebaseAuthException catch (ex) {
        setState(() {
          _showSpinner = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MessageBox(
              title: 'Reset Error',
              content: ex.message.toString(),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image(
                      image: AssetImage('images/logo_with_text_dark.jpg'),
                    ),
                  ),
                  LoginTextFormField(
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _email = value.toString();
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  PushButton(
                    title: 'RESET PASSWORD',
                    onPressed: _submitForm,
                  ),
                  LinkButton(
                    title: 'Login',
                    onPressed: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      Navigator.pushNamed(context, Login.id);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
