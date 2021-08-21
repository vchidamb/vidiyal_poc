import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:vidiyal_login/widgets/search_box.dart';
import 'package:vidiyal_login/widgets/list_box.dart';

class AttendanceClass extends StatefulWidget {
  static const String id = 'attendance_class';

  @override
  _AttendanceClassState createState() => _AttendanceClassState();
}

class _AttendanceClassState extends State<AttendanceClass> {
  TextEditingController _searchController = TextEditingController();
  List _allDocs = [];
  List _filteredDocs = [];
  String _teacherDocId = '';

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
    _getClasses();
  }

  void _getClasses() async {
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;
    _teacherDocId = args[0];

    var data = await FirebaseFirestore.instance
        .collection('teacher')
        .doc(_teacherDocId)
        .collection('class')
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
        title: Text('Select Class'),
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
              screenName: 'class',
              filteredDocs: _filteredDocs,
              teacherDocId: _teacherDocId,
            ),
          ]),
        ),
      ),
    );
  }
}
