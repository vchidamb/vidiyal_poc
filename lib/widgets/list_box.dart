import 'package:flutter/material.dart';
import 'package:vidiyal_login/screens/attendance_class.dart';
import 'package:vidiyal_login/screens/attendance_student.dart';
import 'package:vidiyal_login/screens/attendance.dart';

class ListBox extends StatelessWidget {
  final List filteredDocs;
  final String screenName;

  ListBox({
    required this.filteredDocs,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                elevation: 20,
                child: new ListTile(
                  title: new Text(
                    filteredDocs[index]['name'],
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              onTap: () {
                List<String> args = [filteredDocs[index].id];
                Navigator.pushNamed(
                  context,
                  AttendanceClass.id,
                  arguments: args,
                );
              },
            );
          }),
    );
  }
}
