import 'package:flutter/material.dart';
import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidiyal_login/screens/attendance.dart';
import 'package:vidiyal_login/widgets/search_box.dart';

class AttendanceStudent extends StatefulWidget {
  static const String id = 'attendance_student';

  @override
  _AttendanceStudentState createState() => _AttendanceStudentState();
}

class _AttendanceStudentState extends State<AttendanceStudent> {
  TextEditingController _searchController = TextEditingController();
  List _allDocs = [];
  List _filteredDocs = [];

  String teacherDocId = "", classDocId = "";

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
    List<Map<String, dynamic>> studentMaps = [];

    final docId = ModalRoute.of(context)!.settings.arguments as List<String>;
    teacherDocId = docId[0];
    classDocId = docId[1];

    var data = await FirebaseFirestore.instance
        .collection('teacher')
        .doc(teacherDocId)
        .collection('class')
        .doc(classDocId)
        .collection('class_student')
        .where('active', isEqualTo: 'Y')
        .get();

    for (var doc in data.docs) {
      DocumentSnapshot studentDoc = await doc["student_doc_id"].get();
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
                              classDocId,
                              _filteredDocs[index]['class_student_doc_id']
                            ];
                            Navigator.pushNamed(context, Attendance.id,
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
