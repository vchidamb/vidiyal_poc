import 'package:flutter/material.dart';

import 'package:vidiyal_login/screens/attendance_class.dart';
import 'package:vidiyal_login/screens/attendance_student.dart';
import 'package:vidiyal_login/screens/attendance.dart';

class ListBox extends StatelessWidget {
  final String screenName;
  final List filteredDocs;
  final String teacherDocId;
  final String teacherName;
  final String classDocId;
  final String className;

  ListBox({
    required this.screenName,
    required this.filteredDocs,
    this.teacherDocId = '',
    this.teacherName = '',
    this.classDocId = '',
    this.className = '',
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
                child: ListTile(
                  title: Text(
                    filteredDocs[index]['name'],
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              onTap: () {
                String routeName = '';
                List<List<String>> args = [];

                if (screenName == 'teacher') {
                  routeName = AttendanceClass.id;
                  args.add(
                      [filteredDocs[index].id, filteredDocs[index]['name']]);
                }

                if (screenName == 'class') {
                  routeName = AttendanceStudent.id;
                  args.add([teacherDocId, teacherName]);
                  args.add(
                      [filteredDocs[index].id, filteredDocs[index]['name']]);
                }

                if (screenName == 'student') {
                  routeName = Attendance.id;
                  args.add([teacherDocId, teacherName]);
                  args.add([classDocId, className]);
                  args.add([
                    filteredDocs[index]['class_student_doc_id'],
                    filteredDocs[index]['name']
                  ]);
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
