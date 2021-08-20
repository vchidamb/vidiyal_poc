import 'package:flutter/material.dart';
import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidiyal_login/screens/attendance_class.dart';

class AttendanceTeacher extends StatefulWidget {
  static const String id = 'attendance_teacher';

  @override
  _AttendanceTeacherState createState() => _AttendanceTeacherState();
}

class _AttendanceTeacherState extends State<AttendanceTeacher> {
  TextEditingController _searchController = TextEditingController();
  List _allDocs = [];
  List _filteredDocs = [];

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
        var email = document["email"].toString().toLowerCase();
        var name = document["name"].toString().toLowerCase();

        if (email.contains(_searchController.text.toLowerCase()) ||
            name.contains(_searchController.text.toLowerCase())) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MenuBar(
        appBar: AppBar(),
        leading: BackButton(),
        title: Text('Select Teacher'),
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
                          onPressed: () {
                            List<String> args = [_filteredDocs[index].id];
                            Navigator.pushNamed(context, AttendanceClass.id,
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
