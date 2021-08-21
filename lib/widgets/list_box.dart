import 'package:flutter/material.dart';

import 'package:vidiyal_login/screens/attendance_class.dart';
import 'package:vidiyal_login/screens/attendance_student.dart';
import 'package:vidiyal_login/screens/attendance.dart';

class ListBox extends StatelessWidget {
  final String screenName;
  final List filteredDocs;
  final String teacherDocId;
  final String classDocId;

  ListBox({
    required this.screenName,
    required this.filteredDocs,
    this.teacherDocId = '',
    this.classDocId = '',
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
                String routeName = '';
                List<String> args = [];

                if (screenName == 'teacher') {
                  routeName = AttendanceClass.id;
                  args = [
                    filteredDocs[index].id,
                  ];
                }

                if (screenName == 'class') {
                  routeName = AttendanceStudent.id;
                  args = [
                    teacherDocId,
                    filteredDocs[index].id,
                  ];
                }

                if (screenName == 'student') {
                  routeName = Attendance.id;
                  args = [
                    teacherDocId,
                    classDocId,
                    filteredDocs[index]['class_student_doc_id']
                  ];
                }

                Navigator.pushNamed(
                  context,
                  routeName,
                  arguments: args,
                );
              },
            );
          }),
    );
  }
}
