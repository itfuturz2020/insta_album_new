import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Common/Constants.dart' as constant;
import 'package:insta_album_new/Components/CustomerComponent.dart';

class MychildCustomerList extends StatefulWidget {
  @override
  _MychildCustomerListState createState() => _MychildCustomerListState();
}

class _MychildCustomerListState extends State<MychildCustomerList> {
  bool isLoading = false;
  List ChildGuestData = new List();
  String CustomerId;

  @override
  void initState() {
    GetChildCustomerData();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomerId = prefs.getString(constant.Session.CustomerId);
  }

  GetChildCustomerData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.MyCustomerList(CustomerId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              ChildGuestData = data;
            });
          } else {
            setState(() {
              ChildGuestData=data;
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        bottomNavigationBar: InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/AddCustomer');
          },
          child: Container(
            height: 50,
            color: constant.appPrimaryMaterialColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add),
                Text("Add Invite",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("My Invites"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/Dashboard");
              }),
        ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : ChildGuestData.length > 0
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return ChildCustomerComponent(ChildGuestData[index], () {
                        GetChildCustomerData();
                      });
                    },
                    itemCount: ChildGuestData.length,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("images/no_data.png",
                            width: 40, height: 40, color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("No Invites Found",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
