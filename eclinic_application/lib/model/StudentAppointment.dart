import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StudentAppointment {
  final String appointmentId;
  var appointmentReference;
  final String FacultytId;
  //bool booked;
  final String Day;
  DateTime startTime;
  DateTime endTime;
  String FacultyName;
  String specialityn;

  String meetingMethod;
  String meetingInfo;
  var studentsArrayOfReference;

  StudentAppointment({
    required this.appointmentId,
    required this.appointmentReference,
    required this.FacultytId,
    //required this.booked,
    required this.Day,
    required this.startTime,
    required this.endTime,
    required this.FacultyName,
    required this.specialityn,
    required this.meetingMethod,
    required this.meetingInfo,
  });

  @override
  String toString() {
    // TODO: implement toString
    String srting =
        "Day ${Day} Date:${startTime.year}/${startTime.month}/${startTime.day} time: ${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute} \n";
    return srting;
  }

  String StringDate() {
    // TODO: implement toString
    String srting = "${startTime.day}/${startTime.month}/${startTime.year}";
    return srting;
  }

  String StringTimeRange() {
    // TODO: implement toString
    DateTime tempDate = DateFormat("hh:mm")
        .parse(startTime.hour.toString() + ":" + startTime.minute.toString());
    var dateFormatA = DateFormat("h:mm a");
    var dateFormat = DateFormat("h:mm a");
    DateTime tempDate2 = DateFormat("hh:mm")
        .parse(endTime.hour.toString() + ":" + endTime.minute.toString());
    return dateFormat.format(tempDate) + "-" + dateFormatA.format(tempDate2);
    // return dateFormat.format(tempDate) + "-" + dateFormatA.format(tempDate2);
    // String srting =
    //     "${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}";
    // return srting;
  }

  String OnlyStart() {
    DateTime tempDate = DateFormat("hh:mm")
        .parse(startTime.hour.toString() + ":" + startTime.minute.toString());
    var dateFormat = DateFormat("h:mm a");
    return dateFormat.format(tempDate);
    // String srting = "${startTime.hour}:${startTime.minute}";
    // return srting;
  }

  // String StringStudents() {
  // //   // TODO: implement toString

  // //   String srting = "";
  // //  for (var i = 0; i < students.length; i++) {
  // //   srting= srting+ "${students[i]} - ";
  // //  }

  // //   return srting+"\n";
  // }
}
