import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:vidiyal_login/widgets/menu_action.dart';
import 'package:vidiyal_login/screens/login.dart';
import 'package:vidiyal_login/screens/home.dart';

class MenuBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Widget? leading;
  final Text title;
  final bool centerTitle;
  final bool includeHomeIcon;

  MenuBar({
    required this.appBar,
    this.leading,
    required this.title,
    this.centerTitle = false,
    this.includeHomeIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    List<Widget> actionWidgets = <Widget>[];

    if (includeHomeIcon == true) {
      actionWidgets.add(
        MenuAction(
          icon: FontAwesomeIcons.home,
          onTap: () {
            Navigator.pushNamed(context, Home.id);
          },
          padding: 5,
        ),
      );
    }

    actionWidgets.add(
      MenuAction(
          icon: FontAwesomeIcons.signOutAlt,
          onTap: () {
            _auth.signOut();
            Navigator.popUntil(context, ModalRoute.withName(Login.id));
          },
          padding: 16),
    );

    return AppBar(
      leading: leading,
      title: title,
      centerTitle: centerTitle,
      actions: actionWidgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
