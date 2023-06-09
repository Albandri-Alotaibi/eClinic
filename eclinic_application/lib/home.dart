import 'package:flutter/material.dart';
import 'style/Mycolors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myapp/graduatelogin.dart';
import 'package:myapp/app/constants.dart';
import 'package:myapp/app/shardPreferense.dart';
import 'package:myapp/bloc/select_group/bloc.dart';

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/KSU3.jpg"),
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
            // opacity: 0.6
          ),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset(
              "assets/images/logo.png",
              scale: 5,
              opacity: AlwaysStoppedAnimation(0.3),
            ),
          ),
          Spacer(
            flex: 3,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome  ",
                //textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'bold',
                  fontSize: 47,
                  color: Mycolors.mainColorWhite,
                ),
              ),
              Text(
                "Join us, let's make success happen! ",
                style: TextStyle(
                    fontFamily: 'main',
                    fontSize: 20,
                    color: Mycolors.mainColorWhite),
              ),
            ],
          ),
          Spacer(
            flex: 1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Mycolors.mainColorWhite,
                  textStyle: TextStyle(fontSize: 16),
                  // shadowColor: Colors.blue[900],
                  elevation: 0,
                  backgroundColor: Color.fromARGB(135, 21, 70, 160),
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17), // <-- Radius
                    side: BorderSide(
                        width: 2, color: Mycolors.mainShadedColorBlue),
                  ),
                ),
                onPressed: () {
                  TypeUser.type = 'faculty';
                  StorageManager.saveData('TypeUser', 'faculty');
                  Navigator.pushNamed(context, 'login');
                },
                child: Text('Faculty Member'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Mycolors.mainColorWhite,
                  textStyle: TextStyle(fontSize: 16),
                  // shadowColor: Colors.blue[900],
                  elevation: 0,

                  backgroundColor: Color.fromARGB(135, 21, 70, 160),
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17), // <-- Radius
                    side: BorderSide(
                        width: 2, color: Mycolors.mainShadedColorBlue),
                  ),
                ),
                onPressed: () {
                  TypeUser.type = 'student';
                  StorageManager.saveData('TypeUser', 'student');
                  Navigator.pushNamed(context, 'studentlogin');
                },
                child: Text('Student'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Mycolors.mainColorWhite,
                  textStyle: TextStyle(fontSize: 16),
                  // shadowColor: Colors.blue[900],
                  elevation: 0,
                  backgroundColor: Color.fromARGB(135, 21, 70, 160),
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17), // <-- Radius
                    side: BorderSide(
                        width: 2, color: Mycolors.mainShadedColorBlue),
                  ),
                ),
                onPressed: () {
                  TypeUser.type = 'graduate';
                  // save type user
                  StorageManager.saveData('TypeUser', 'graduate');
                  Navigator.pushNamed(context, 'graduatelogin');
                },
                child: Text('Graduate'),
              ),
            ],
          ),
          SizedBox(
            height: 75,
          ),
          Row()
        ]),
      ),
    ));
  }
}
