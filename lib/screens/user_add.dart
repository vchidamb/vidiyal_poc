import 'package:flutter/material.dart';
import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAdd extends StatefulWidget {
  static const String id = 'user_add';

  @override
  _UserAddState createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final dropdownState = GlobalKey<FormFieldState>();

  String email = "", name = "", role = "", studentDocId = "", teacherDocId = "";

  List<DropdownMenuItem<String>> _roles = [
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

        await user.add(
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MenuBar(
        appBar: AppBar(),
        leading: BackButton(),
        title: Text('Add User'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
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
                ElevatedButton(onPressed: _sendToServer, child: Text('Add'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
