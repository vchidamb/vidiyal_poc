import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vidiyal_login/components/tile.dart';
import 'package:vidiyal_login/components/app_bar.dart';
import 'package:vidiyal_login/screens/attendance.dart';
import 'package:vidiyal_login/screens/attendance_teacher.dart';
import 'package:vidiyal_login/screens/user_profile.dart';

class Home extends StatefulWidget {
  static const String id = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BaseAppBar(
        appBar: AppBar(),
        leading: new Container(),
        title: Text('Home'),
        actions: ['Logout'],
      ),
      body: SafeArea(
        child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              Tile(
                title: 'Attendance',
                icon: FontAwesomeIcons.tasks,
                onTapped: () {
                  Navigator.pushNamed(context, AttendanceTeacher.id);
                },
              ),
              // Tile(
              //   title: 'Class',
              //   icon: FontAwesomeIcons.chalkboard,
              //   onTapped: () {},
              // ),
              // Tile(
              //   title: 'Payment',
              //   icon: FontAwesomeIcons.fileInvoiceDollar,
              //   onTapped: () {},
              // ),
              Tile(
                title: 'Student',
                icon: FontAwesomeIcons.userGraduate,
                onTapped: () {
                  Navigator.pushNamed(context, Attendance.id);
                },
              ),
              Tile(
                title: 'Teacher',
                icon: FontAwesomeIcons.chalkboardTeacher,
                onTapped: () {},
              ),
              Tile(
                title: 'User Profile',
                icon: FontAwesomeIcons.users,
                onTapped: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
              ),
            ]),
      ),
    );
  }
}
