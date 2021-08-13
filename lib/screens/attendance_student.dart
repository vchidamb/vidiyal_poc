import 'package:flutter/material.dart';
import 'package:vidiyal_login/components/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    Future resultsLoaded = _getDocsFromDatabase();
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
    final docId = ModalRoute.of(context)!.settings.arguments as List<String>;
    teacherDocId = docId[0];
    classDocId = docId[1];

    var data = await FirebaseFirestore.instance
        .collection('teacher')
        .doc(teacherDocId)
        .collection('class')
        .doc(classDocId)
        .collection('class_student')
        .get();

    List<DocumentSnapshot> studentDocs = [];
    for (var doc in data.docs) {
      var studentDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(doc["student_doc_id"])
          .get();
      studentDocs.add(studentDoc);
    }

    setState(() {
      _allDocs = studentDocs;
      _filteredDocs = studentDocs;
    });

    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BaseAppBar(
        appBar: AppBar(),
        leading: BackButton(),
        title: Text('Select Student'),
        actions: ['Home', 'Logout'],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                          onPressed: () {},
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
