// @dart=2.9
import 'components/rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String titLe = "Pause";

Widget bodyWidget;

CountDownController controller = CountDownController();

int duration = 10;
int _break = 5;

bool start = true;

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
  bool swap = false;
  var _duration;

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
        "It will ring in $duration minutes.", notificationDetails);
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
    if (swap) {
      // this should be !swap, it's swap to test push-notifications
      bodyWidget = Center(
          child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 7),
        child: DurationPicker(
          duration: _duration,
          onChange: (val) {
            this.setState(() => _duration = val);
          },
          snapToMins: 5.0,
        ),
      ));
    } else {
      bodyWidget = Center(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 7),
          child: CircularCountDownTimer(
              // Countdown duration in Seconds.
              duration: duration,

              // Countdown initial elapsed Duration in Seconds.
              initialDuration: 0,

              // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
              controller: controller,

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
                  titLe = "Pause";
                });
              },

              // This Callback will execute when the Countdown Ends.
              onComplete: () {
                setState(() {
                  _showNotificationOnEnd();
                  swap = !swap;
                });
              }),
        ),
      );
    }

    if (start) {
      return Scaffold(
          appBar: AppBar(title: Text('Pomodoro Clock'), centerTitle: true),
          body: bodyWidget,
          floatingActionButton: ActionButton1());
    } else {
      start = false;
      return Scaffold(
          appBar: AppBar(title: Text('Pomodoro Clock'), centerTitle: true),
          body: bodyWidget,
          floatingActionButton: ActionButton2());
    }
  }
}
