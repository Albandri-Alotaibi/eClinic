import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/login.dart';

class facultyhome extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  const facultyhome({super.key});

  @override
  State<facultyhome> createState() => _fState();
}

class _fState extends State<facultyhome> {
  String? email = '';
  String? userid = '';

  @override
  Widget build(BuildContext context) {
    body:
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return facultyhome();
          } else {
            return login();
          }
        }));
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    userid = user!.uid;
    email = user.email!;
    // This method is rerun every time setState is called,
    // for instance, as done by the _increment method above.
    // The Flutter framework has been optimized to make
    // rerunning build methods fast, so that you can just
    // rebuild anything that needs updating rather than
    // having to individually changes instances of widgets.

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addHoursFaculty');
          },
          child: Text('addHoursFaculty'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'FacultyVievBookedAppointment');
          },
          child: Text('BookedAppointment'),
        ),
        const SizedBox(width: 16),




      ],
    );
  }
}
