import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateToString on DateTime {




  convertToWord(){
    return DateFormat('MMM yyyy').format(this) ;
  }

  convertToWordMonth(){
    return month < 10 ? '0$month' : month  ;
  }
  convertToWordYears(){
    return DateFormat('yyyy').format(this) ;
  }




}


extension ChangedForString on String {

  arabicEquatable(){
    return replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا').replaceAll('ى', 'ا').replaceAll('ة', 'ه');
  }

}


extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}


extension RefToString on DocumentReference? {

  String  toStringNameDepartement(){
    return this?.path.split('/').last  ?? 'IS';
  }

}


extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> removeNullValues() {
    return Map<K, V>.fromEntries(entries.where((e) => e.value != null));
  }
}



extension StringEmtyToNull on String {
  String? toNullIfEmplty() {
    return  isEmpty ? null : this ;
  }
}

