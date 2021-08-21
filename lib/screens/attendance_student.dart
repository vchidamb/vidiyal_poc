import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:vidiyal_login/widgets/search_box.dart';
import 'package:vidiyal_login/widgets/list_box.dart';

class AttendanceStudent extends StatefulWidget {
  static const String id = 'attendance_student';

  @override
  _AttendanceStudentState createState() => _AttendanceStudentState();
}

class _AttendanceStudentState extends State<AttendanceStudent> {
  TextEditingController _searchController = TextEditingController();
  List _allDocs = [];
  List _filteredDocs = [];
  String _teacherDocId = '', _classDocId = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchFieldChange);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchFieldChange);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getStudents();
  }

  void _getStudents() async {
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;
    _teacherDocId = args[0];
    _classDocId = args[1];

    List<Map<String, dynamic>> studentMaps = [];

    var data = await FirebaseFirestore.instance
        .collection('teacher')
        .doc(_teacherDocId)
        .collection('class')
        .doc(_classDocId)
        .collection('class_student')
        .where('active', isEqualTo: 'Y')
        .get();

    for (var doc in data.docs) {
      DocumentSnapshot studentDoc = await doc['student_doc_id'].get();
      Map<String, dynamic> studentMap =
          studentDoc.data() as Map<String, dynamic>;
      studentMap['class_student_doc_id'] = doc.reference.id;
      studentMaps.add(studentMap);
    }

    setState(() {
      _allDocs = studentMaps;
      _filteredDocs = studentMaps;
    });
  }

  void _searchFieldChange() {
    List searchResults = [];
    String name;

    if (_searchController.text != '') {
      for (var doc in _allDocs) {
        name = doc['name'].toString().toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          searchResults.add(doc);
        }
      }
    } else {
      searchResults = _allDocs;
    }

    setState(() {
      _filteredDocs = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MenuBar(
        appBar: AppBar(),
        leading: BackButton(),
        title: Text('Select Student'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            SearchBox(
              searchController: _searchController,
            ),
            SizedBox(
              height: 8,
            ),
            ListBox(
              screenName: 'student',
              filteredDocs: _filteredDocs,
              teacherDocId: _teacherDocId,
              classDocId: _classDocId,
            ),
          ]),
        ),
      ),
    );
  }
}
