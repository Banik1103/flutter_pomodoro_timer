// ignore: import_of_legacy_library_into_null_safe
import 'package:pomodoro_timer/main.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:page_transition/page_transition.dart';

class DDrawer extends StatefulWidget {
  @override
  _DDrawerState createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 90,
            child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Navigation',
                  style: TextStyle(fontSize: 28.5),
                )),
          ),
          Card(
            child: ListTile(
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: HomePage()));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Study Techniques'),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: StudyTechniques()));
              },
            ),
          ),
        ],
      )),
    );
  }
}
