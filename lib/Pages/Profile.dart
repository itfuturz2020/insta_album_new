import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String CustomerId = "", Name = "", Email = "", Mobile = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String CustId = preferences.getString(Session.CustomerId);
    String CustName = preferences.getString(Session.Name);
    String CustEmail = preferences.getString(Session.Email);
    String CustMobile = preferences.getString(Session.Mobile);
    setState(() {
      CustomerId = CustId;
      Name = CustName;
      Email = CustEmail;
      Mobile = CustMobile;
    });
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    //name
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2.7,
                            //color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Name',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          Text(
                            ':',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            //color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${Name}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Mobile
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2.7,
                            //color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Mobile Number',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          Text(
                            ':',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            //color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${Mobile}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Email
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2.7,
                            //color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Email',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          Text(
                            ':',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            //color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${Email}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
