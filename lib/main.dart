// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String _title = "Pause";

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage(swap: false));
  }
}

class HomePage extends StatefulWidget {
  final bool swap;

  HomePage({Key key, this.swap}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CountDownController _controller = CountDownController();
  int _duration = 10;
  int _break = 5;

  bool swap = false;

  FlutterLocalNotificationsPlugin localNotification;

  @override
  void initState() {
    super.initState();
    swap = widget.swap;
    var androidInitialize = AndroidInitializationSettings('study');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification = FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  Future _showNotificationOnStart() async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Clock Notification", "Description",
        importance: Importance.high);
    var iOSDetails = IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await localNotification.show(0, "The Pomodoro Timer started!",
        "It will ring in $_duration minutes.", notificationDetails);
  }

  Future _showNotificationOnEnd() async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Clock Notification", "Description",
        importance: Importance.high);
    var iOSDetails = IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await localNotification.show(0, "The time is up!",
        "Good job, now you can rest for $_break minutes.", notificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    Widget actionButton;

    if (swap) {
      // this should be !swap, it's swap to test push-notifications
      bodyWidget = Container();
      actionButton = Container();
    } else {
      bodyWidget = Center(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 7),
          child: CircularCountDownTimer(
            // Countdown duration in Seconds.
            duration: _duration,

            // Countdown initial elapsed Duration in Seconds.
            initialDuration: 0,

            // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
            controller: _controller,

            // Width of the Countdown Widget.
            width: MediaQuery.of(context).size.width / 2,

            // Height of the Countdown Widget.
            height: MediaQuery.of(context).size.height / 2,

            // Ring Color for Countdown Widget.
            ringColor: Colors.grey[300],

            // Ring Gradient for Countdown Widget.
            ringGradient: null,

            // Filling Color for Countdown Widget.
            fillColor: Colors.purpleAccent[100],

            // Filling Gradient for Countdown Widget.
            fillGradient: null,

            // Background Color for Countdown Widget.
            backgroundColor: Colors.purple[500],

            // Background Gradient for Countdown Widget.
            backgroundGradient: null,

            // Border Thickness of the Countdown Ring.
            strokeWidth: 20.0,

            // Begin and end contours with a flat edge and no extension.
            strokeCap: StrokeCap.round,

            // Text Style for Countdown Text.
            textStyle: TextStyle(
                fontSize: 33.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),

            // Format for the Countdown Text.
            textFormat: CountdownTextFormat.S,

            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
            isReverse: true,

            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
            isReverseAnimation: true,

            // Handles visibility of the Countdown Text.
            isTimerTextShown: true,

            // Handles the timer start.
            autoStart: false,

            // This Callback will execute when the Countdown Starts.
            onStart: () {
              setState(() {
                _showNotificationOnStart();
                _title = "Pause";
              });
            },

            // This Callback will execute when the Countdown Ends.
            onComplete: () {
              // Push notification comes here
              setState(() {
                _showNotificationOnEnd();
                swap = !swap;
              });
            },
          ),
        ),
      );
      actionButton = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
          ),
          _button(
              title: "Start",
              onPressed: () {
                _controller.start();
              }),
          SizedBox(
            width: 10,
          ),
          _button(
              title: _title,
              onPressed: () {
                if (_title == "Pause") {
                  _controller.pause();
                  setState(() {
                    _title = "Resume";
                  });
                } else {
                  _controller.resume();
                  setState(() {
                    _title = "Pause";
                  });
                }
              }),
          SizedBox(
            width: 10,
          ),
          _button(
              title: "Restart",
              onPressed: () => _controller.restart(duration: _duration))
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(title: Text('Pomodoro Clock'), centerTitle: true),
        body: bodyWidget,
        floatingActionButton: actionButton);
  }
}

_button({String title, VoidCallback onPressed}) {
  return Expanded(
      child: ElevatedButton(
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed));
}
