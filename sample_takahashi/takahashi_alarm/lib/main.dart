import 'package:flutter/material.dart';

import 'next_page.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> titleList = ['Amazon', '楽天', 'Yahoo!'];
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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

  //定時実行バックグランド起動のスクリプト記述
  // Future _showNotification() async {
  //   var time = new Time(15, 30, 0);
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High);
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   print("_showNotification start");
  //   print(time.hour.toString());
  //   print("now :" + DateTime.now().toString());
  //   await flutterLocalNotificationsPlugin.showDailyAtTime(
  //     0,
  //     'Timer',
  //     'You should check the app',
  //     time,
  //     platformChannelSpecifics,
  //     payload: 'Default_Sound',
  //   );
  //   print(flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails());
  // }

  //即時で通知を出すメソッド
  // Future _showNotification() async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High);
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'plain title', 'plain body', platformChannelSpecifics,
  //       payload: 'item id 2');
  // }

  //X分後に実行するメソッド **時間のタイムゾーンがおかしい
  // Future _showNotification() async {
  //   var scheduledNotificationDateTime =
  //       new DateTime.now().add(new Duration(seconds: 5));
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your other channel id', 'channel name', 'channelDescription');
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   NotificationDetails platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   print("showNotification started");
  //   print(DateTime.now().toString());
  //   print(RepeatInterval.EveryMinute.index);
  //print(scheduledNotificationDateTime.toString());
  //   await flutterLocalNotificationsPlugin.schedule(
  //       0,
  //       'scheduled title',
  //       'scheduled body',
  //       scheduledNotificationDateTime,
  //       platformChannelSpecifics);
  // }

  //   await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
  //       'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
  // }

  //サンプルコード②を参照＝＞成功！！
  Future _showNotification() async {
    var time = Time(15, 10, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id', 'channel name', 'channelDescription');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print("showNotification started");
    print(DateTime.now().toString());
    print(time.hour.toString() + ":" + time.minute.toString());
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0, 'repeating title', 'repeating body', time, platformChannelSpecifics);
  }

  //
  // Future _showNotification() async {
  //   var time = Time(14, 55, 0);
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your other channel id', 'channel name', 'channelDescription');
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   NotificationDetails platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   print("showNotification started");
  //   print(DateTime.now().toString());
  //   print(time.hour.toString() + ":" + time.minute.toString());
  //print(scheduledNotificationDateTime.toString());
  //   await flutterLocalNotificationsPlugin.schedule(
  //       0,
  //       'scheduled title',
  //       'scheduled body',
  //       scheduledNotificationDateTime,
  //       platformChannelSpecifics);
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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
        title: Text("パスワード管理"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            ListTile(
                leading: Icon(Icons.security),
                title: Text(titleList[index]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NextPage(titleList[index])));
                }),
            Divider(),
          ]);
        },
        itemCount: titleList.length,
      ),
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
