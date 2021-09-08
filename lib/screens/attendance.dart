import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:vidiyal_login/utils.dart';
import 'package:vidiyal_login/constants.dart';
import 'package:vidiyal_login/widgets/menu_bar.dart';

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

  DateTime _focusedDay = kFirstDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _teacherDocId = '',
      _teacherName = '',
      _classDocId = '',
      _className = '',
      _classStudentDocId = '',
      _classStudentName = '';
  CollectionReference _attendanceReference =
      FirebaseFirestore.instance.collection('teacher');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDates();
  }

  void _getDates() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as List<List<String>>;
    _teacherDocId = args[0][0];
    _teacherName = args[0][1];
    _classDocId = args[1][0];
    _className = args[1][1];
    _classStudentDocId = args[2][0];
    _classStudentName = args[2][1];

    _attendanceReference = FirebaseFirestore.instance
        .collection('teacher')
        .doc(_teacherDocId)
        .collection('class')
        .doc(_classDocId)
        .collection('class_student')
        .doc(_classStudentDocId)
        .collection('class_attendance');

    var data = await _attendanceReference
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

      await _attendanceReference
          .where('class_date', isEqualTo: selectedDay)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } else {
      _selectedDays.add(selectedDay);
      await _attendanceReference.add({'class_date': selectedDay});
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Teacher: ' + _teacherName,
                  style: kTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Class: ' + _className,
                  style: kTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Student: ' + _classStudentName,
                  style: kTextStyle,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 5,
                thickness: 2,
                color: LogoBlue,
              ),
              TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  titleCentered: true,
                  headerPadding: EdgeInsets.symmetric(vertical: 20),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: false,
                  selectedDecoration: BoxDecoration(
                    color: LogoBlue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle:
                      TextStyle(color: Colors.black, fontSize: 13),
                  weekendTextStyle: TextStyle(color: Colors.white),
                  disabledTextStyle: TextStyle(color: Colors.grey[700]),
                ),
                selectedDayPredicate: (day) {
                  return _selectedDays.contains(day);
                },
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
