import 'package:flutter/material.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class home extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    // for instance, as done by the _increment method above.
    // The Flutter framework has been optimized to make
    // rerunning build methods fast, so that you can just
    // rebuild anything that needs updating rather than
    // having to individually changes instances of widgets.
    return SafeArea(
        child: Scaffold(
      backgroundColor: Mycolors.BackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/KSU3.jpg"),
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
            // opacity: 0.6
          ),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 200, right: 120),
            child: Text(
              "Welcome  ",
              style: TextStyle(
                  fontFamily: 'bold',
                  fontSize: 50,
                  color: Mycolors.mainColorWhite),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: Text(
              "Join us, let's make success happen! ",
              style: TextStyle(
                  fontFamily: 'main',
                  fontSize: 20,
                  color: Mycolors.mainColorWhite),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 280,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                    // shadowColor: Colors.blue[900],
                    elevation: 0,
                    backgroundColor: Mycolors.mainShadedColorBlue,
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'studentlogin');
                  },
                  child: Text('Student'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontFamily: 'main', fontSize: 16),
                    // shadowColor: Colors.blue[900],
                    elevation: 0,
                    backgroundColor: Mycolors.mainShadedColorBlue,
                    minimumSize: Size(20, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Text('Faculty Member'),
                ),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
