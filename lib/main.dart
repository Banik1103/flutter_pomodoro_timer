// @dart=2.9
import 'components/rows.dart';
import 'components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:pomodoro_timer/components/buttons.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String titLe = "Pause";

int duration = 0;
int breakDuration = 0;

bool clicked = false;
bool clicked2 = false;

CountDownController controller = CountDownController();
CountDownController controller2 = CountDownController();

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: DurationPickerOne());
  }
}

class DurationPickerOne extends StatefulWidget {
  @override
  _DurationPickerOneState createState() => _DurationPickerOneState();
}

class _DurationPickerOneState extends State<DurationPickerOne> {
  Duration _duration = Duration(hours: 0, minutes: 0);

  throwError() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text('Error'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('The duration entered cannot be used. Try again.')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    child: Text('Okay', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pomodoro Timer'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 70),
                child: Text('How long do you want to study for?'),
              ), // change font size!
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 7),
                child: DurationPicker(
                  duration: _duration,
                  onChange: (val) {
                    this.setState(() => _duration = val);
                  },
                  snapToMins: 5.0,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30),
            ControlButton(
                title: 'Next',
                buttonTapped: () {
                  duration = _duration.inMinutes;
                  if (duration < 1) {
                    throwError();
                  } else {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: DurationPickerTwo()));
                  }
                })
          ],
        ));
  }
}

class DurationPickerTwo extends StatefulWidget {
  @override
  _DurationPickerTwoState createState() => _DurationPickerTwoState();
}

class _DurationPickerTwoState extends State<DurationPickerTwo> {
  Duration _duration = Duration(hours: 0, minutes: 0);

  throwError() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text('Error'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('The duration entered cannot be used. Try again.')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    child: Text('Okay', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Pomodoro Timer'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 70),
                  child: Text('How long do you want your break to be?'),
                ), // change font size!
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 7),
                  child: DurationPicker(
                    duration: _duration,
                    onChange: (val) {
                      this.setState(() => _duration = val);
                    },
                    snapToMins: 5.0,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(width: 30),
            ControlButton(
                title: 'Next',
                buttonTapped: () {
                  breakDuration = _duration.inMinutes;
                  if (breakDuration < 1) {
                    throwError();
                  } else {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: TimerScreenOne()));
                  }
                })
          ])),
    );
  }
}

class TimerScreenOne extends StatefulWidget {
  @override
  _TimerScreenOneState createState() => _TimerScreenOneState();
}

class _TimerScreenOneState extends State<TimerScreenOne> {
  FlutterLocalNotificationsPlugin localNotification;

  @override
  void initState() {
    super.initState();
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
    if (duration == 1) {
      await localNotification.show(0, "The Pomodoro Timer started!",
          "It will end in $duration minute.", notificationDetails);
    } else {
      await localNotification.show(0, "The Pomodoro Timer started!",
          "It will end in $duration minutes.", notificationDetails);
    }
  }

  Future _showNotificationOnEnd() async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Clock Notification", "Description",
        importance: Importance.high);
    var iOSDetails = IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    if (breakDuration == 1) {
      await localNotification.show(
          0,
          "The time is up!",
          "Good job, now you can rest for $breakDuration minute.",
          notificationDetails);
    } else {
      await localNotification.show(
          0,
          "The time is up!",
          "Good job, now you can rest for $breakDuration minutes.",
          notificationDetails);
    }
  }

  Widget build(BuildContext context) {
    Widget bodyWidget;

    bodyWidget = Center(
        child: Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 7),
      child: CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: duration * 60,

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
            fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.MM_SS,

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
          });
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () {
          setState(() {
            _showNotificationOnEnd();
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TimerScreenTwo()));
          });
        },
      ),
    ));

    if (!clicked) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Pomodoro Timer'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: bodyWidget,
            floatingActionButton: ActionButton1()),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Pomodoro Timer'),
                centerTitle: true,
                automaticallyImplyLeading: false),
            body: bodyWidget,
            floatingActionButton: ActionButton2()),
      );
    }
  }
}

class TimerScreenTwo extends StatefulWidget {
  @override
  _TimerScreenTwoState createState() => _TimerScreenTwoState();
}

class _TimerScreenTwoState extends State<TimerScreenTwo> {
  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    bodyWidget = Center(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 7),
        child: CircularCountDownTimer(
          // Countdown duration in Seconds.
          duration: breakDuration * 60,

          // Countdown initial elapsed Duration in Seconds.
          initialDuration: breakDuration * 60,

          // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
          controller: controller2,

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
              fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),

          // Format for the Countdown Text.
          textFormat: CountdownTextFormat.MM_SS,

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
            setState(() {});
          },

          // This Callback will execute when the Countdown Ends.
          onComplete: () {},
        ),
      ),
    );

    if (!clicked2) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Pomodoro Timer'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: bodyWidget,
            floatingActionButton: ActionButton3()),
      );
    } else {
      return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              appBar: AppBar(
                  title: Text('Pomodoro Timer'),
                  centerTitle: true,
                  automaticallyImplyLeading: false),
              body: bodyWidget));
    }
  }
}
