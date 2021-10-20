import 'package:flutter/material.dart';
import 'package:helios_test/utils.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    Key? key,
    required this.onPressed,
    required this.number,
    required this.hovered,
  }) : super(key: key);

  final void Function()? onPressed;
  final int number;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      child: Center(child: Text("$number")),
      backgroundColor: hovered ? lightGreen : green,
      onPressed: onPressed,
    );
  }
}
