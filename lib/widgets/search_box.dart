import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController searchController;

  SearchBox({
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white54,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
