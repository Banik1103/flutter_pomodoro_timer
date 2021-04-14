// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';
import '../components/buttons.dart';
import 'package:flutter/material.dart';

class ActionButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 30),
      ControlButton(
        title: 'Start',
        buttonTapped: () {
          controller.start();
          start = false;
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
