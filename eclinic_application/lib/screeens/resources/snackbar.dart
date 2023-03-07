import 'package:flutter/material.dart';


void showInSnackBar(context , String value , {color = Colors.green , bool onError = false  }) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
            backgroundColor: onError ? Colors.red :  color,
            content: Text( (onError ? 'Error : ' : '') + value, style: Theme
                .of(context)
                .textTheme
                .button
                ?.copyWith(fontSize: 15, color: Colors.white ), textAlign: TextAlign.center,)));
  }catch(e){
    debugPrint('error from snack bar ') ;
  }
}
