import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Pages/AboutUs.dart';
import 'package:insta_album_new/Pages/NotificationPage.dart';
import 'package:insta_album_new/Pages/Profile.dart';
import 'package:insta_album_new/Pages/Settings.dart';
import 'package:insta_album_new/Screen/AnimatedBottomBar.dart';
import 'package:insta_album_new/Screen/CustomerGalleryScreen.dart';
import 'package:insta_album_new/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  StreamSubscription iosSubscription;

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        print("FFFFFFFF" + data.toString());
        saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }

    /*var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _showDailyAtTime();*/
  }

  Future<void> _showDailyAtTime() async {
    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      sound: 'slow_spring_board',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        //'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  final List<Widget> _children = [
    CustomerGallery(),
    Profile(),
    NotificationPage(),
    AboutUs(),
    Settings(),
  ];
  List<BarItem> barItems = [
    BarItem(text: "Home", iconData: Icons.home, color: Colors.teal),
    BarItem(
        text: "Profile", iconData: Icons.person, color: Colors.yellow.shade900),
    BarItem(
        text: "Notification",
        iconData: Icons.notifications_active,
        color: Colors.deepOrange.shade600),
    BarItem(text: "About Us", iconData: Icons.info, color: Colors.lightGreen),
    BarItem(text: "Settings", iconData: Icons.settings, color: Colors.blue),
  ];

  List<String> titleList = [
    "Home",
    "Profile",
    "Notification",
    "About PICTIK",
    "Settings",
  ];

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      setState(() {
        //fcmToken = token;
        sendFCMTokan(token);
      });
      print("FCM Token : $token");
    });
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              /*await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );*/
            },
          )
        ],
      ),
    );
  }

  //send fcm token
  sendFCMTokan(var FcmToken) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SendTokanToServer(FcmToken);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, "/Login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(titleList[_currentIndex].toString()),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _logout();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: AnimatedBottomBar(
          barItems: barItems,
          animationDuration: Duration(milliseconds: 350),
          onBarTab: (index) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}
