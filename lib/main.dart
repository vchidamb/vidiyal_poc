import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:vidiyal_login/constants.dart';

import 'package:vidiyal_login/screens/register.dart';
import 'package:vidiyal_login/screens/login.dart';
import 'package:vidiyal_login/screens/reset_password.dart';
import 'package:vidiyal_login/screens/home.dart';
import 'package:vidiyal_login/screens/user.dart';
import 'package:vidiyal_login/screens/user_add.dart';
import 'package:vidiyal_login/screens/user_update.dart';
import 'package:vidiyal_login/screens/attendance.dart';
import 'package:vidiyal_login/screens/attendance_teacher.dart';
import 'package:vidiyal_login/screens/attendance_class.dart';
import 'package:vidiyal_login/screens/attendance_student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VidiyalApp());
}

class VidiyalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: LogoBlue,
        fontFamily: 'Nunito',
      ),
      initialRoute: Login.id,
      routes: {
        Register.id: (context) => Register(),
        Login.id: (context) => Login(),
        ResetPassword.id: (context) => ResetPassword(),
        Home.id: (context) => Home(),
        User.id: (context) => User(),
        UserAdd.id: (context) => UserAdd(),
        UserUpdate.id: (context) => UserUpdate(),
        Attendance.id: (context) => Attendance(),
        AttendanceTeacher.id: (context) => AttendanceTeacher(),
        AttendanceClass.id: (context) => AttendanceClass(),
        AttendanceStudent.id: (context) => AttendanceStudent(),
      },
    );
  }
}
