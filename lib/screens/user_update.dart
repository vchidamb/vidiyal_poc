import 'package:flutter/material.dart';
import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserUpdate extends StatefulWidget {
  static const String id = 'user_update';

  @override
  _UserUpdateState createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final dropdownState = GlobalKey<FormFieldState>();

  String email = "",
      name = "",
      role = "",
      studentDocId = "",
      teacherDocId = "",
      docId = "";

  List<DropdownMenuItem<String>> _roles = [
    DropdownMenuItem(
      child: Text(""),
      value: "",
    ),
    DropdownMenuItem(
      child: Text("Admin"),
      value: "A",
    ),
    DropdownMenuItem(
      child: Text("Teacher"),
      value: "T",
    ),
  ];

  _sendToServer() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Processing data')));

      _formKey.currentState!.save();

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        CollectionReference user =
            FirebaseFirestore.instance.collection('user');

        DocumentReference docRef = user.doc(docId);

        await docRef.update(
          {
            "email": "$email",
            "name": "$name",
            "role": "$role",
            "student_doc_id": "$studentDocId",
            "teacher_doc_id": "$teacherDocId"
          },
        );

        Navigator.pop(context);
      });
    } else {
      // validation error
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as QueryDocumentSnapshot<Map<String, dynamic>>;

    docId = args.reference.id;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MenuBar(
        appBar: AppBar(),
        leading: BackButton(),
        title: Text('Update User'),
        actions: ['Home', 'Logout'],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                    initialValue: args["name"],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      name = value.toString();
                    }),
                TextFormField(
                    initialValue: args["email"],
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      email = value.toString();
                    }),
                DropdownButtonFormField(
                  value: args["role"],
                  dropdownColor: Colors.black,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  items: _roles,
                  onSaved: (value) {
                    role = value.toString();
                  },
                  onChanged: (value) {
                    setState(() {
                      role = value.toString();
                    });
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(onPressed: _sendToServer, child: Text('Update'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
