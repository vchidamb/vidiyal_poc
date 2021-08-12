import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vidiyal_login/constants.dart';
import 'package:vidiyal_login/components/rounded_button.dart';
import 'package:vidiyal_login/screens/register.dart';
import 'package:vidiyal_login/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showSpinner = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
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
                SizedBox(
                  height: 48,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    controller: emailController,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Email address'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    textAlign: TextAlign.center,
                    controller: passwordController,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'Password'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                RoundedButton(
                  title: 'LOGIN',
                  color: Color(0xFF43C5EF),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        emailController.clear();
                        passwordController.clear();
                        Navigator.pushNamed(context, Home.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } on FirebaseAuthException catch (e) {
                      print(e.message);
                      setState(() {
                        showSpinner = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Login Error"),
                            content: Text(e.message.toString()),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF43C5EF),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, Register.id);
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    TextButton(
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF43C5EF),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await _auth.sendPasswordResetEmail(email: email);
                          setState(() {
                            showSpinner = false;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Password Reset"),
                                  content: Text(
                                      'An email has been sent with link to reset the password.'),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } on FirebaseAuthException catch (e) {
                          print(e.message);
                          setState(() {
                            showSpinner = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Password Reset Error"),
                                content: Text(e.message.toString()),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
