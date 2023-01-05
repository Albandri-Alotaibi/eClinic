import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GPlist {
  var id;
  String GPname;
  String CodeLink;
  String FileUrl;
  List GPcategory;
  List Students;
  var semester;
  GPlist({
    required this.id,
    required this.GPname,
    required this.CodeLink,
    required this.FileUrl,
    required this.GPcategory,
    required this.Students,
    required this.semester,
  });
  @override
  String toString() {
    // TODO: implement toString
    String text =
        'id: ${id}, GPname: ${GPname} CodeLink: ${CodeLink},  FileUrl: ${FileUrl}, GPcategory: ${GPcategory}, Students: ${Students}, semester:${semester}';
    return text;
  }

  String categoryAndsemester() {
    String AllCategory = "";
    for (int i = 0; i < GPcategory.length; i++) {
      AllCategory = AllCategory + GPcategory[i] + ", ";
    }
    String text = ' GP category: ${AllCategory}  semester:${semester}';
    return text;
  }
}
