import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;
  ProgressDialog pr;
  List soundData = [];

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    _getLocal();

  }

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString(cnst.Session.PlayMusic) == "true") {
        isSwitched = true;
      } else {
        isSwitched = false;
      }
    });
  }



  _changePlayMusic(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cnst.Session.PlayMusic, value.toString());
    setState(() {
      isSwitched = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Slide Show Speed"),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Play Music"),
            trailing: Switch(
              value: isSwitched,
              onChanged: (value) {
                _changePlayMusic(value);
              },
              activeTrackColor: cnst.appPrimaryMaterialColor[500],
              activeColor: cnst.appPrimaryMaterialColor,
            ),
          ),
          Divider(
            thickness: 2,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/SelectSound');
            },
            child: ListTile(
              title: Text("Select Music"),
            ),
          ),
          Divider(
            thickness: 2,
          ),
        ],
      ),
    ));
  }
}
