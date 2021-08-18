import 'package:flutter/material.dart';

final kToday = DateTime.now();
final kFirstDay =
    DateTime(kToday.year, kToday.month - 1, 1); // First day of previous month
final kLastDay = DateTime(
    kToday.year, kToday.month, kToday.day); // Last day of current month
// final kLastDay = DateTime(kToday.year, kToday.month + 1, 0); // Last day of current month

const LogoBlue = Color(0xFF44C5EF);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white70, width: 3),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
);
