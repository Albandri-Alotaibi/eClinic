import 'package:flutter/material.dart';
import 'package:myapp/UploadGPG.dart';
import 'package:myapp/style/Mycolors.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _Loading();
}

class _Loading extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(
                color: Mycolors.mainShadedColorBlue)));
  }

  @override
  void initState() {
    super.initState;
    cry();
  }

  cry() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadGPG(),
      ),
    );
  }
}
