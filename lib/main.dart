import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insta_album_new/Screen/Dashboard.dart';
import 'package:insta_album_new/Screen/GuestDashboard.dart';
import 'package:insta_album_new/Screen/Login.dart';
import 'package:insta_album_new/Screen/MyInvites.dart';
import 'package:insta_album_new/Screen/OTPVerification.dart';
import 'package:insta_album_new/Screen/PortfolioScreen.dart';
import 'package:insta_album_new/Screen/SelectSound.dart';
import 'package:insta_album_new/Screen/SignUpGuest.dart';
import 'package:insta_album_new/Screen/Splash.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

import 'Screen/AddCustomer.dart';
import 'Screen/BookAppointment.dart';
import 'Screen/ContactList.dart';
import 'Screen/SocialLink.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/*void main() => runApp(MyApp());*/
void main() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is th e root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage");

      print(message);
    }, onResume: (Map<String, dynamic> message) {
      print("onResume");
      print(message);
    }, onLaunch: (Map<String, dynamic> message) {
      print("onLaunch");
      print(message);
    });

    //For Ios Notification
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Setting reqistered : $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Cloud',
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/Login': (context) => Login(),
        '/OTPVerification': (context) => OTPVerification(),
        '/Dashboard': (context) => Dashboard(),
        '/PortfolioScreen': (context) => PortfolioScreen(),
        '/AddCustomer': (context) => AddCustomer(),
        '/ContactList': (context) => ContactList(),
        '/SocialLink': (context) => SocialLink(),
        '/BookAppointment': (context) => BookAppointment(),
        '/SignUpGuest': (context) => SignUpGuest(),
        '/GuestDashboard': (context) => GuestDashboard(),
        '/MyCustomer': (context) => MychildCustomerList(),
        '/SelectSound': (context) => SelectSound(),
      },
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: cnst.appPrimaryMaterialColor,
        accentColor: Colors.black,
        buttonColor: cnst.appPrimaryMaterialColor,
      ),
    );
  }
}
