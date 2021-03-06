import 'package:flutter/material.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime.utc(
    kToday.year, kToday.month - 1, 1); // First day of previous month
final kLastDay =
    DateTime.utc(kToday.year, kToday.month, 0); // Last day of previous month

// final kLastDay = DateTime.utc(kToday.year, kToday.month, kToday.day); // Current Date
// final kLastDay = DateTime.utc(kToday.year, kToday.month + 1, 0); // Last day of current month + 1

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

const kTextStyle = TextStyle(
  fontSize: 15,
  letterSpacing: 0.5,
);
