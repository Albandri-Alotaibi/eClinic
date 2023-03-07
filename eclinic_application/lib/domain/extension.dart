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
