import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vidiyal_login/screens/register.dart';
import 'package:vidiyal_login/screens/login.dart';
import 'package:vidiyal_login/screens/home.dart';
import 'package:vidiyal_login/screens/user_profile.dart';
import 'package:vidiyal_login/screens/user_profile_add.dart';
import 'package:vidiyal_login/screens/user_profile_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VidiyalApp());
}

class VidiyalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Login.id,
      routes: {
        Register.id: (context) => Register(),
        Login.id: (context) => Login(),
        Home.id: (context) => Home(),
        UserProfile.id: (context) => UserProfile(),
        UserProfileAdd.id: (context) => UserProfileAdd(),
        UserProfileUpdate.id: (context) => UserProfileUpdate(),
      },
    );
  }
}
