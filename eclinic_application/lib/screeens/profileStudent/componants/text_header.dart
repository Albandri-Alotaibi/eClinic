import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  const TextHeader({
    super.key, required this.text,
  });
  final String text ;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text , style:  Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold ,
            fontSize: 17
        ),),
      ],
    );
  }
}
