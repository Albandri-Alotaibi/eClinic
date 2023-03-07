import 'package:flutter/foundation.dart';

class Failure {
  final String error ;

  Failure(this.error){
    debugPrint('error : $error') ;
  }

}