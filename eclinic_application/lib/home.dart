import 'package:flutter/material.dart';

// class home extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {

//   }

// }

class home extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  const home({super.key});

  @override
  State<home> createState() => _CounterState();
}

class _CounterState extends State<home> {
  @override
  Widget build(BuildContext context) {
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
            Navigator.pushNamed(context, 'deem');
          },
          child: Text('deem'),
        ),
        
        const SizedBox(width: 16),
        
      ],
    );
  }
}
