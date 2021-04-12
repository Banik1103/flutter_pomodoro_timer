// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';
import 'package:flutter/material.dart';
import '../components/buttons.dart';

class ActionButton1 extends StatefulWidget {
  @override
  _ActionButton1State createState() => _ActionButton1State();
}

class _ActionButton1State extends State<ActionButton1> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 30),
      ControlButton(
        title: 'Start',
        buttonTapped: () {
          setState(() {
            controller.start();
            start = false;
          });
        },
      ),
    ]);
  }
}

class ActionButton2 extends StatefulWidget {
  @override
  _ActionButton2State createState() => _ActionButton2State();
}

class _ActionButton2State extends State<ActionButton2> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 30),
      ControlButton(
          title: titLe,
          buttonTapped: () {
            if (titLe == "Pause") {
              controller.pause();
              setState(() {
                titLe = "Resume";
              });
            } else {
              controller.resume();
              setState(() {
                titLe = "Pause";
              });
            }
          }),
      SizedBox(width: 10),
      ControlButton(
        title: 'Restart',
        buttonTapped: () => controller.restart(duration: duration),
      )
    ]);
  }
}
