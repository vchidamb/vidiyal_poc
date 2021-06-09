import 'package:flutter/material.dart';
import 'package:vidiyal_login/components/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  static const String id = 'user_profile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
    Future resultsLoaded = _getDocsFromDatabase();
  }

  _searchFieldChange() {
    List showDocs = [];

    if (_searchController.text != "") {
      for (var document in _allDocs) {
        var userId = document["user_id"].toString().toLowerCase();
        var name = document["name"].toString().toLowerCase();

        if (userId.contains(_searchController.text.toLowerCase()) ||
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
    var data =
        await FirebaseFirestore.instance.collection('user_profile').get();

    setState(() {
      _allDocs = data.docs;
      _filteredDocs = data.docs;
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
        title: Text('User Profile'),
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
                      fillColor: Colors.white,
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
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _filteredDocs.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 20,
                    color: Color(0xFF44C5EF),
                    child: new ListTile(
                      title: new Text(
                        _filteredDocs[index]['name'],
                        style: TextStyle(color: Colors.grey.shade900),
                      ),
                      subtitle: new Text(
                        _filteredDocs[index]['user_id'],
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {},
                      ),
                    ),
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
