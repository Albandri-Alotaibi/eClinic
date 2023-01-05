import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class viewOneGP extends StatefulWidget {
  viewOneGP({super.key, required this.GPid});
  var GPid;
  @override
  State<viewOneGP> createState() => _viewOneGPState();
}

class _viewOneGPState extends State<viewOneGP> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text(widget.GPid));
  }
}
