import 'package:flutter/material.dart';

Future<void> buildShowDialog(
    { required BuildContext context, required String title, required Widget child , Color?  backGroundColor , bool barrierDismissible = true }) {
  return showDialog(
    barrierDismissible: barrierDismissible,
    // user must tap button!
      context: context, builder: (context){
    return AlertDialog(
      backgroundColor: backGroundColor,
      title: Row(
        children: [
          InkWell(
              onTap: (){
                //Navigator.pop(context) ;
              },
              child: const  SizedBox()
          ) ,
          //Spacer() ,
         const  SizedBox(),
          Expanded(child:
          Center(child: Text(title , style: const  TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),))),
        ],
      ),
      content: child,

    ) ;
  });
}





showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content:  Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}
