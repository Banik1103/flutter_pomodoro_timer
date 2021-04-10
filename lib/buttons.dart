import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final String title;
  final color;
  final buttonTapped;

  ControlButton({required this.title, this.color, this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: buttonTapped,
        child: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
