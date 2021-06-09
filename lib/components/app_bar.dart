import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vidiyal_login/screens/login.dart';
import 'package:vidiyal_login/screens/home.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Widget leading;
  final Text title;
  final List<String> actions;

  const BaseAppBar(
      {Key? key,
      required this.appBar,
      required this.leading,
      required this.title,
      required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actionWidgets = <Widget>[];
    String action;
    final _auth = FirebaseAuth.instance;

    Widget homeIcon = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Home.id);
          },
          child: FaIcon(
            FontAwesomeIcons.home,
            color: Colors.white,
          ),
        ),
      ),
    );

    Widget logoutIcon = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () {
            _auth.signOut();
            Navigator.popUntil(context, ModalRoute.withName(Login.id));
          },
          child: FaIcon(
            FontAwesomeIcons.signOutAlt,
            color: Colors.white,
          ),
        ),
      ),
    );

    for (action in actions) {
      if (action == 'Home') {
        actionWidgets.add(homeIcon);
      }
      if (action == 'Logout') {
        actionWidgets.add(logoutIcon);
      }
    }

    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      leading: leading,
      title: title,
      actions: actionWidgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
