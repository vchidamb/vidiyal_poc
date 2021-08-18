import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:vidiyal_login/widgets/push_button.dart';
import 'package:vidiyal_login/widgets/link_button.dart';
import 'package:vidiyal_login/widgets/login_textformfield.dart';
import 'package:vidiyal_login/widgets/message_box.dart';
import 'package:vidiyal_login/screens/login.dart';
import 'package:vidiyal_login/screens/home.dart';

class Register extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '', _password = '', _name = '';
  bool _showSpinner = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FocusManager.instance.primaryFocus!.unfocus();
      setState(() {
        _showSpinner = true;
      });

      try {
        await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        setState(() {
          _showSpinner = false;
        });

        await FirebaseFirestore.instance.collection('user').add({
          'email': _email.toLowerCase(),
          'name': _name,
          'role': '',
          'student_doc_id': '',
          'teacher_doc_id': '',
        });

        // Minimize the keyboard and go to home page
        FocusManager.instance.primaryFocus!.unfocus();
        Navigator.pushNamed(context, Home.id);
      } on FirebaseAuthException catch (ex) {
        setState(() {
          _showSpinner = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MessageBox(
              title: 'Registration Error',
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
                    hintText: 'Name',
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) {
                      _name = value.toString();
                    },
                  ),
                  SizedBox(
                    height: 8,
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
                  LoginTextFormField(
                    hintText: 'Password',
                    obscureText: true,
                    onSaved: (value) {
                      _password = value.toString();
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  PushButton(
                    title: 'REGISTER',
                    onPressed: _submitForm,
                  ),
                  LinkButton(
                    title: 'Login',
                    onPressed: () {
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
