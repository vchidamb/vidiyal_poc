import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vidiyal_login/components/app_bar.dart';
import 'package:vidiyal_login/screens/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileUpdate extends StatefulWidget {
  static const String id = 'user_profile_update';

  // final String docId;
  // UserProfileUpdate(this.docId);

  @override
  _UserProfileUpdateState createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final dropdownState = GlobalKey<FormFieldState>();

  bool _validate = false;
  String email = "",
      name = "",
      role = "",
      studentDocId = "",
      teacherDocId = "",
      docId = "";

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
        CollectionReference userProfile =
            FirebaseFirestore.instance.collection('user_profile');

        DocumentReference docRef = userProfile.doc(docId);

        var result = await docRef.update(
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
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(args["docId"]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BaseAppBar(
        appBar: AppBar(),
        leading: BackButton(),
        title: Text('Add User Profile'),
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
                  style: TextStyle(color: Colors.black, fontSize: 20),
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
