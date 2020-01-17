import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.Session.CustomerId);
      String veri = prefs.getString(cnst.Session.IsVerified);
      String Type = prefs.getString(cnst.Session.Type);

      if (MemberId != null && MemberId != "" && veri == "true") {
        if (Type.toString() == "Guest") {
          Navigator.pushReplacementNamed(context, '/GuestDashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/Dashboard');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/Login');
      }
      /*//Navigator.pushReplacementNamed(context, '/Login');
      Navigator.pushReplacementNamed(context, '/Dashboard');*/
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/om.png",
                width: 150.0, height: 150.0, fit: BoxFit.contain),
            /*Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'The Studio Om',
                style: TextStyle(
                    color: cnst.secondaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700
                    //fontSize: 18.0,
                    ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
