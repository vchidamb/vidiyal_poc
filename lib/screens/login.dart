import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:vidiyal_login/widgets/push_button.dart';
import 'package:vidiyal_login/widgets/link_button.dart';
import 'package:vidiyal_login/widgets/message_box.dart';
import 'package:vidiyal_login/widgets/login_textformfield.dart';
import 'package:vidiyal_login/screens/register.dart';
import 'package:vidiyal_login/screens/reset_password.dart';
import 'package:vidiyal_login/screens/home.dart';

class Login extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '', _password = '';
  bool _showSpinner = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FocusManager.instance.primaryFocus!.unfocus();
      setState(() {
        _showSpinner = true;
      });

      try {
        await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        _emailController.clear();
        _passwordController.clear();

        setState(() {
          _showSpinner = false;
        });

        Navigator.pushNamed(context, Home.id);
      } on FirebaseAuthException catch (ex) {
        setState(() {
          _showSpinner = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MessageBox(
              title: 'Login Error',
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
                    textEditingController: _emailController,
                    onSaved: (value) {
                      _email = value.toString();
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  LoginTextFormField(
                    hintText: 'Password',
                    obscureText: true,
                    textEditingController: _passwordController,
                    onSaved: (value) {
                      _password = value.toString();
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  PushButton(
                    title: 'LOGIN',
                    onPressed: _submitForm,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinkButton(
                        title: 'Register',
                        onPressed: () {
                          Navigator.pushNamed(context, Register.id);
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      LinkButton(
                        title: 'Reset Password',
                        onPressed: () {
                          Navigator.pushNamed(context, ResetPassword.id);
                        },
                      ),
                    ],
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
