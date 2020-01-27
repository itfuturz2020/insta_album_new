import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Pages/AboutUs.dart';
import 'package:insta_album_new/Pages/GuestHome.dart';
import 'package:insta_album_new/Pages/NotificationPage.dart';
import 'package:insta_album_new/Pages/Profile.dart';
import 'package:insta_album_new/Screen/AnimatedBottomBar.dart';

class GuestDashboard extends StatefulWidget {
  @override
  _GuestDashboardState createState() => _GuestDashboardState();
}

class _GuestDashboardState extends State<GuestDashboard> {
  int _currentIndex = 0;
  StreamSubscription iosSubscription;
  bool dialVisible = true;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

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
  }

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
    prefs.remove(cnst.Session.CustomerId);
    prefs.remove(cnst.Session.IsVerified);
    prefs.remove(cnst.Session.StudioId);
    prefs.remove(cnst.Session.Name);
    prefs.remove(cnst.Session.Mobile);
    prefs.remove(cnst.Session.Type);
    Navigator.pushReplacementNamed(context, "/Login");
  }

  List<String> titleList = [
    "Portfolio",
    "Profile",
    "Notification",
    "About Photo Cloud",
  ];

  List<BarItem> barItems = [
    BarItem(text: "Portfolio", iconData: Icons.work, color: Colors.teal),
    BarItem(
        text: "Profile", iconData: Icons.person, color: Colors.yellow.shade900),
    BarItem(
        text: "Notification",
        iconData: Icons.notifications_active,
        color: Colors.deepOrange.shade600),
    BarItem(text: "About Us", iconData: Icons.info, color: Colors.lightGreen),
  ];

  final List<Widget> _children = [
    GuestHome(),
    Profile(),
    NotificationPage(),
    AboutUs(),
  ];

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
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 8,
        marginBottom: 8,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(
          size: 22.0,
        ),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: dialVisible,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        //tooltip: 'Speed Dial',
        //heroTag: 'speed-dial-hero-tag',
        backgroundColor: cnst.appPrimaryMaterialColor,
        foregroundColor: Colors.black,
        //child: Icon(Icons.add),
        elevation: 4.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.access_time),
              backgroundColor: Colors.deepPurple,
              label: 'Book Appointment',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushNamed(context, '/BookAppointment');
              }),
          /*SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: 'Add Customer',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/AddCustomer');
              }),
          SpeedDialChild(
              child: Icon(Icons.brush),
              backgroundColor: Colors.blue,
              label: 'View Portfolio',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushNamed(context, '/PortfolioScreen');
              }),*/
          SpeedDialChild(
            child: Icon(Icons.link),
            backgroundColor: Colors.green,
            label: 'Social Link',
            labelStyle: TextStyle(fontSize: 17.0),
            onTap: () {
              Navigator.pushNamed(context, '/SocialLink');
            },
          ),
        ],
      ),
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
      body: _children[_currentIndex],
    );
  }
}
