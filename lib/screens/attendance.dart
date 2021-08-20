import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:vidiyal_login/widgets/menu_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vidiyal_login/constants.dart';
import 'package:vidiyal_login/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance extends StatefulWidget {
  static const String id = 'attendance';

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = kFirstDay;
  String teacherDocId = "", classDocId = "", classStudentDocId = "";
  CollectionReference attendanceReference =
      FirebaseFirestore.instance.collection('teacher');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDates();
  }

  void _getDates() async {
    final docId = ModalRoute.of(context)!.settings.arguments as List<String>;
    teacherDocId = docId[0];
    classDocId = docId[1];
    classStudentDocId = docId[2];
    attendanceReference = FirebaseFirestore.instance
        .collection('teacher')
        .doc(teacherDocId)
        .collection('class')
        .doc(classDocId)
        .collection('class_student')
        .doc(classStudentDocId)
        .collection('class_attendance');

    var data = await attendanceReference
        .where('class_date', isGreaterThanOrEqualTo: kFirstDay)
        .where('class_date', isLessThanOrEqualTo: kLastDay)
        .get();

    for (var doc in data.docs) {
      _selectedDays.add((doc['class_date']).toDate().toUtc());
    }

    setState(() {});
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    _focusedDay = focusedDay;

    if (_selectedDays.contains(selectedDay)) {
      _selectedDays.remove(selectedDay);

      await attendanceReference
          .where('class_date', isEqualTo: selectedDay.toUtc())
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } else {
      _selectedDays.add(selectedDay);
      await attendanceReference.add({'class_date': selectedDay.toUtc()});
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MenuBar(
        appBar: AppBar(),
        leading: BackButton(),
        title: Text('Mark Attendance'),
        actions: ['Home', 'Logout'],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: false,
              selectedTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              disabledTextStyle: TextStyle(color: Colors.grey[700]),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.blue),
              weekendStyle: TextStyle(color: Colors.blue),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.blue),
            ),
            selectedDayPredicate: (day) {
              return _selectedDays.contains(day);
            },
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}
