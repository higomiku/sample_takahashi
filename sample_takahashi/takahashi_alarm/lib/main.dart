import 'dart:io' as io;
import 'dart:math';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'next_page.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//AudioRecorderのimport宣言
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  //runApp(MyApp());
  runApp(MyAudioRecordApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyAudioRecordApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyAudioRecordApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin audio recorder'),
        ),
        body: new AppBody(),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AppBody({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new AppBodyState();
}

class AppBodyState extends State<AppBody> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                onPressed: _isRecording ? null : _start,
                child: new Text("Start"),
                color: Colors.green,
              ),
              new FlatButton(
                onPressed: _isRecording ? _stop : null,
                child: new Text("Stop"),
                color: Colors.red,
              ),
              new TextField(
                controller: _controller,
                decoration: new InputDecoration(
                  hintText: 'Enter a custom path',
                ),
              ),
              new Text("File path of the record: ${_recording.path}"),
              new Text("Format: ${_recording.audioOutputFormat}"),
              new Text("Extension : ${_recording.extension}"),
              new Text(
                  "Audio recording duration : ${_recording.duration.toString()}")
            ]),
      ),
    );
  }

  _start() async {
    try {
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_MUSIC);
      print("path=" + path);
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text;
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
    _controller.text = recording.path;
  }
}

class NotificationContent {
  var androidPlatformChannelSpecifics;
  var iOSPlatformChannelSpecifics;
  NotificationDetails platformChannelSpecifics;
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  // List<String> titleList = ['Amazon', '楽天', 'Yahoo!'];
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var notificationContent = new NotificationContent();

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

  void loadSE() {
    _assetsAudioPlayer.open(
      Audio("assets/door_chime0.mp3"),
    );
  }

  void playSE() {
    _assetsAudioPlayer.play();
    // print("playSE is called");
  }

  NotificationContent pepareForNotificationContent() {
    var tmpNotificationContent = new NotificationContent();
    tmpNotificationContent.androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
            'your other channel id', 'channel name', 'channelDescription');
    tmpNotificationContent.iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    tmpNotificationContent.platformChannelSpecifics = new NotificationDetails(
        tmpNotificationContent.androidPlatformChannelSpecifics,
        tmpNotificationContent.iOSPlatformChannelSpecifics);

    return tmpNotificationContent;
  }

  //即時で通知を出すメソッド
  // Future _showNotification() async {
  // notificationContent = pepareForNotificationContent();
  // await flutterLocalNotificationsPlugin.show(
  //       0, 'plain title', 'plain body',notificationContent.platformChannelSpecifics,
  //       payload: 'item id 2');
  // }

  //X分後に実行するメソッド **時間のタイムゾーンがおかしい
  // Future _showNotification() async {
  // notificationContent = pepareForNotificationContent();
  //   await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
  //       'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
  // }

  //サンプルコード②を参照＝＞成功！！
  Future _showNotification() async {
    var time = Time(13, 03, 0);
    notificationContent = pepareForNotificationContent();
    print("showNotification started");
    print(DateTime.now().toString());
    print(time.hour.toString() + ":" + time.minute.toString());
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'repeating title',
        'repeating body', time, notificationContent.platformChannelSpecifics);
  }

  //
  // Future _showNotification() async {
  //   var time = Time(14, 55, 0);
  // notificationContent = pepareForNotificationContent();
  //   print("showNotification started");
  //   print(DateTime.now().toString());
  //   print(time.hour.toString() + ":" + time.minute.toString());
  //print(scheduledNotificationDateTime.toString());
  //   await flutterLocalNotificationsPlugin.schedule(
  //       0,
  //       'scheduled title',
  //       'scheduled body',
  //       scheduledNotificationDateTime,
  //       notificationContent.platformChannelSpecifics);
  // }

  //通知をクリックした時の動作を定義するメソッドらしい。
  // Future onSelectNotification(String payload) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Text(payload),
  //       maintainState : false,),
  //     );
  // }

  void _setScheduler() {
    _showNotification();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        title: Text("アラーム機能"),
      ),
      // body: ListView.builder(
      //   itemBuilder: (BuildContext context, int index) {
      //     return Column(children: <Widget>[
      //       ListTile(
      //           leading: Icon(Icons.security),
      //           title: Text(titleList[index]),
      //           onTap: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => NextPage(titleList[index])));
      //           }),
      //       Divider(),
      //     ]);
      //   },
      //   itemCount: titleList.length,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // loadSE();
          // playSE();
          // titleList.clear();
          //titleList.add('Google');
          //setState(() {});
          print("onPressed started");
          _setScheduler();
          // print(titleList);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
