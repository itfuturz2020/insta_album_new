import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Constants.dart' as constant;
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:url_launcher/url_launcher.dart';

class ChildCustomerComponent extends StatefulWidget {
  var ChildGuestData;
  Function onDelete;

  ChildCustomerComponent(this.ChildGuestData, this.onDelete);

  @override
  _ChildCustomerComponentState createState() => _ChildCustomerComponentState();
}

class _ChildCustomerComponentState extends State<ChildCustomerComponent> {
  List VehicleData = new List();
  bool isLoading = false;
  String StudioId;
  static String Applink = "";

  ProgressDialog pr;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StudioId = prefs.getString(constant.Session.StudioId);
  }

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: constant.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    _getLocaldata();
  }

  _deleteChildGuest(String ChildGuestId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.DeleteChileCustomer(ChildGuestId).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
            });
            widget.onDelete();
          } else {
            data.Data;
            isLoading = false;
            showHHMsg("Vehicle Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  _GetAppLink() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Services.ShareAppMessage(StudioId).then((data) async {
          if (data.Data == "1") {
            pr.hide();
            setState(() {
              Applink = data.Message;
            });
            widget.onDelete();
            Share.share(data.Message.toString());
          } else {
            pr.hide();
            showHHMsg("Something Went Wrong", "");
          }
        }, onError: (e) {
          pr.hide();
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  _UpdateInviteStatus(String ChildGuestId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Services.UpdateInviteStatus(ChildGuestId).then((data) async {
          if (data.Data == "1") {
            pr.hide();
            _GetAppLink();
          } else {
            pr.hide();
            showHHMsg("Something Went Wrong", "");
          }
        }, onError: (e) {
          pr.hide();
          showHHMsg("$e", "");
          pr.hide();
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are You Sure You Want To Delete?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteChildGuest(Id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage("images/man.png"), fit: BoxFit.cover),
                borderRadius: BorderRadius.all(new Radius.circular(75.0)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('${widget.ChildGuestData["Name"]}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(81, 92, 111, 1))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                    child: Text('${widget.ChildGuestData["Mobile"]}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700])),
                  ),
                  widget.ChildGuestData["InviteStatus"] == "Pending"
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 1.0, top: 3.0, bottom: 4.0),
                          child: Text(
                            'Pending',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          ),
                        )
                      : widget.ChildGuestData["IsVerified"] == null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 1.0, top: 3.0, bottom: 4.0),
                              child: Text(
                                'Invited',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 1.0, top: 3.0, bottom: 4.0),
                              child: Text(
                                'App Downloaded',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber),
                              ),
                            ),
                ],
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () {
                launch("tel:" + '${widget.ChildGuestData["Mobile"]}');
              }),
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.grey,
              ),
              onPressed: () {
                _UpdateInviteStatus('${widget.ChildGuestData["Id"]}');
                // widget.onDelete();
              }),
          IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400]),
              onPressed: () {
                _showConfirmDialog('${widget.ChildGuestData["Id"]}');
              })
        ],
      ),
    );
  }
}
