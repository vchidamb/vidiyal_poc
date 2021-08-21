import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:vidiyal_login/widgets/search_box.dart';
import 'package:vidiyal_login/widgets/list_box.dart';

class AttendanceTeacher extends StatefulWidget {
  static const String id = 'attendance_teacher';

  @override
  _AttendanceTeacherState createState() => _AttendanceTeacherState();
}

class _AttendanceTeacherState extends State<AttendanceTeacher> {
  TextEditingController _searchController = TextEditingController();
  List _allDocs = [], _filteredDocs = [];

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
    _getTeachers();
  }

  void _getTeachers() async {
    var data = await FirebaseFirestore.instance
        .collection('teacher')
        .where('active', isEqualTo: 'Y')
        .orderBy('name')
        .get();

    setState(() {
      _allDocs = data.docs;
      _filteredDocs = data.docs;
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
        title: Text('Select Teacher'),
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
              screenName: 'teacher',
              filteredDocs: _filteredDocs,
            ),
          ]),
        ),
      ),
    );
  }
}
