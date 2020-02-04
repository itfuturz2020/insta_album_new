import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List giveData = [];
  bool isLoading = false;

  ProgressDialog pr;

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
    _getGive();
  }

  _getGive() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetAboutUs();
        /*setState(() {
          isLoading = true;
        });*/
        pr.show();
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              giveData = data;
              //isLoading = false;
            });
          } else {
            /*setState(() {
              isLoading = false;
            });*/
            pr.hide();
          }
        }, onError: (e) {
          /*setState(() {
            isLoading = false;
          });*/
          pr.hide();
          print("Error : on Myask Call $e");
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        child: Scaffold(
      body: isLoading
          ? LoadinComponent()
          : giveData != null
          ? Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: ListView.builder(
          itemCount: giveData.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.white,
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      giveData[index]["Title"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      giveData[index]["Description"],
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ));
          },
        ),
      )
          : NoDataComponent(),
        ), onWillPop: onWillPop);
  }
}
