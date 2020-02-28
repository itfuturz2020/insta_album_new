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

  _showSpeedDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SlideShow();
      },
    );
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
          GestureDetector(
            onTap: () {
              _showSpeedDialog();
            },
            child: ListTile(
              title: Text("Speed"),
              subtitle: Text("SlideShow Speed(s)"),
            ),
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
            onTap: () {
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

class SlideShow extends StatefulWidget {
  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  double _value;

  @override
  void initState() {
    getLocal();
  }

  getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString(cnst.Session.SlideShowSpeed) == "" ||
          prefs.getString(cnst.Session.SlideShowSpeed) == null) {
        _value = 1.5;
      } else {
        _value = double.parse(prefs.getString(cnst.Session.SlideShowSpeed));
      }
    });
  }

  setSlideShowTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String CustomerId = prefs.getString(Session.CustomerId);
    prefs.setString(cnst.Session.SlideShowSpeed, _value.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Slide Show Speed"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Slider(
            value: _value,
            min: 0.5,
            max: 5.0,
            divisions: 9,
            label: 'Slide Show Speed',
            onChanged: (double newValue) {
              setState(() {
                _value = newValue;
                print("selected value: ${_value}");
              });
            },
          ),
          Text("${_value} Seconds")
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("Close",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Ok",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          onPressed: () {
            setSlideShowTime();
          },
        ),
      ],
    );
  }
}
