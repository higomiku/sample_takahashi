import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
  final String sound;
  NextPage(this.sound);
}

class NotificationContent {
  var androidPlatformChannelSpecifics;
  var iOSPlatformChannelSpecifics;
  NotificationDetails platformChannelSpecifics;
}

class _NextPageState extends State<NextPage> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var notificationContent = new NotificationContent();

  var _labelText = 'Select Date';

  TimeOfDay timeOfDay;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // void loadSE() {
  void loadSE(filepath) {
    _assetsAudioPlayer.open(
      Audio(filepath),
    );
  }

  void playSE() {
    _assetsAudioPlayer.play();
    // print("playSE is called");
  }

  NotificationContent pepareForNotificationContent() {
    var tmpNotificationContent = new NotificationContent();
    AndroidNotificationSound sound =
        new UriAndroidNotificationSound(widget.sound);
    tmpNotificationContent.androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
            'your other channel id', 'channel name', 'channelDescription',
            sound: sound);
    // );

    tmpNotificationContent.iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    tmpNotificationContent.platformChannelSpecifics = new NotificationDetails(
        tmpNotificationContent.androidPlatformChannelSpecifics,
        tmpNotificationContent.iOSPlatformChannelSpecifics);

    return tmpNotificationContent;
  }

  Future _setScheduler(TimeOfDay timeOfDay) async {
    //var time = Time(13, 03, 0);
    Time time = new Time(timeOfDay.hour, timeOfDay.minute);

    notificationContent = pepareForNotificationContent();

    print("showNotification started");
    print(DateTime.now().toString());
    print(time.hour.toString() + ":" + time.minute.toString());
    print(timeOfDay);
    print(time);
    print(notificationContent.androidPlatformChannelSpecifics.toString());
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'repeating title',
        'repeating body', time, notificationContent.platformChannelSpecifics);
  }

  Future<void> _selectTime(BuildContext context) async {
    timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      var dt = _toDateTime(timeOfDay);
      setState(() {
        _labelText = (DateFormat.Hm()).format(dt);
      });
    }
  }

  _toDateTime(TimeOfDay t) {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        title: Text("アラーム機能"),
      ),
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(children: <Widget>[
              Text(
                _labelText,
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () => _selectTime(context),
              )
            ]),
          )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // loadSE();
          // playSE();
          // titleList.clear();
          //titleList.add('Google');
          //setState(() {});
          print("onPressed started");
          print("ReceivedTimeOfDay");
          print(timeOfDay);
          if (timeOfDay != null) {
            _setScheduler(timeOfDay);
          } else {
            print("its null!!");
          }
          // print(titleList);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class NotificationAssets {
//   AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   var notificationContent = new NotificationContent();

//   @override
//   void initState() {
//     var initializationSettingsAndroid =
//         new AndroidInitializationSettings('app_icon');
//     var initializationSettingsIOS = new IOSInitializationSettings();
//     var initializationSettings = new InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
//     flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   void loadSE() {
//     _assetsAudioPlayer.open(
//       Audio("assets/door_chime0.mp3"),
//     );
//   }

//   void playSE() {
//     _assetsAudioPlayer.play();
//     // print("playSE is called");
//   }

//   NotificationContent pepareForNotificationContent() {
//     var tmpNotificationContent = new NotificationContent();
//     tmpNotificationContent.androidPlatformChannelSpecifics =
//         new AndroidNotificationDetails(
//             'your other channel id', 'channel name', 'channelDescription');
//     tmpNotificationContent.iOSPlatformChannelSpecifics =
//         new IOSNotificationDetails();
//     tmpNotificationContent.platformChannelSpecifics = new NotificationDetails(
//         tmpNotificationContent.androidPlatformChannelSpecifics,
//         tmpNotificationContent.iOSPlatformChannelSpecifics);

//     return tmpNotificationContent;
//   }

//   Future _showNotification() async {
//     var time = Time(13, 03, 0);
//     notificationContent = pepareForNotificationContent();
//     print("showNotification started");
//     print(DateTime.now().toString());
//     print(time.hour.toString() + ":" + time.minute.toString());
//     await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'repeating title',
//         'repeating body', time, notificationContent.platformChannelSpecifics);
//   }

//   void _setScheduler() {
//     _showNotification();
//   }
// }
