import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:vidiyal_login/widgets/search_box.dart';
import 'package:vidiyal_login/screens/attendance_student.dart';

class AttendanceClass extends StatefulWidget {
  static const String id = 'attendance_class';

  @override
  _AttendanceClassState createState() => _AttendanceClassState();
}

class _AttendanceClassState extends State<AttendanceClass> {
  TextEditingController _searchController = TextEditingController();
  List _allDocs = [];
  List _filteredDocs = [];

  String teacherDocId = "";

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
    _getDocsFromDatabase();
  }

  _searchFieldChange() {
    List showDocs = [];

    if (_searchController.text != "") {
      for (var document in _allDocs) {
        var name = document["name"].toString().toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          showDocs.add(document);
        }
      }
    } else {
      showDocs = _allDocs;
    }

    setState(() {
      _filteredDocs = showDocs;
    });
  }

  _getDocsFromDatabase() async {
    // final args = ModalRoute.of(context)!.settings.arguments
    //     as QueryDocumentSnapshot<Map<String, dynamic>>;
    // teacherDocId = args.reference.id;

    final docId = ModalRoute.of(context)!.settings.arguments as List<String>;
    teacherDocId = docId[0];

    var data = await FirebaseFirestore.instance
        .collection('teacher')
        .doc(teacherDocId)
        .collection('class')
        .where('active', isEqualTo: 'Y')
        .orderBy('name')
        .get();

    setState(() {
      _allDocs = data.docs;
      _filteredDocs = data.docs;
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
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredDocs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 20,
                      // color: Color(0xFF44C5EF),
                      child: new ListTile(
                        title: new Text(
                          _filteredDocs[index]['name'],
                          // style: TextStyle(color: Color(0xFFffd54f)),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            List<String> args = [
                              teacherDocId,
                              _filteredDocs[index].id
                            ];
                            Navigator.pushNamed(context, AttendanceStudent.id,
                                arguments: args);
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
