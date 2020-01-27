import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Common/Services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController edtMobile = new TextEditingController();

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
    //pr.setMessage('Please Wait');
    // TODO: implement initState
    super.initState();
  }

  checkLogin() async {
    if (edtMobile.text != "" && edtMobile.text != null) {
      if (edtMobile.text.length == 10) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            /*setState(() {
              isLoading = true;
            });*/
            pr.show();
            Future res = Services.MemberLogin(edtMobile.text);
            res.then((data) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (data != null && data.length > 0) {
                pr.hide();
                await prefs.setString(
                    Session.CustomerId, data[0]["Id"].toString());
                await prefs.setString(
                    Session.ParentId, data[0]["ParentId"].toString());

                await prefs.setString(Session.Name, data[0]["Name"].toString());
                await prefs.setString(
                    Session.Mobile, data[0]["Mobile"].toString());
                await prefs.setString(
                    Session.Email, data[0]["Email"].toString());

                await prefs.setString(
                    Session.StudioId, data[0]["StudioId"].toString());

                await prefs.setString(
                    Session.IsVerified, data[0]["IsVerified"].toString());

                await prefs.setString(Session.Type, data[0]["Type"].toString());
                await prefs.setString(Session.PinSelection, "false");

                if (data[0]["IsVerified"].toString() == "true") {
                  if (data[0]["Type"].toString() == "Guest") {
                    Navigator.pushReplacementNamed(context, '/GuestDashboard');
                  } else {
                    Navigator.pushReplacementNamed(context, '/Dashboard');
                  }
                } else {
                  Navigator.pushReplacementNamed(context, '/OTPVerification');
                }
              } else {
                pr.hide();
                showMsg("Invalid login Detail.");
              }
            }, onError: (e) {
              pr.hide();
              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            pr.hide();
            showMsg("No Internet Connection.");
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else {
        showMsg("Please Enter Valid Mobile No.");
      }
    } else {
      showMsg("Please Enter Mobile No.");
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
                style: TextStyle(color: Colors.black),
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //print("height : ${height}");
    /*return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: cnst.appPrimaryMaterialColor[400],
          child: Stack(
            children: <Widget>[
              Container(
                height:height > 600.0 ?240:190,
                width: MediaQuery.of(context).size.width,
                //color: cnst.appPrimaryMaterialColor[400],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Image.asset("images/icon_login.png",
                          width: 180.0, height: 90.0, fit: BoxFit.fill),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: height > 600.0 ?240:190),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15.0, // has the effect of softening the shadow
                      spreadRadius: 2.0, // has the effect of extending the shadow
                      offset: Offset(
                        10.0, // horizontal, move right 10
                        10.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25, left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: edtMobile,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  hintText: "Enter Mobile Number"),
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10),
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(7.0)),
                              color: cnst.appPrimaryMaterialColor,
                              minWidth: MediaQuery.of(context).size.width - 20,
                              onPressed: () {
                                checkLogin();
                                //Navigator.pushReplacementNamed(context, '/OTPVerification');
                              },
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset("images/icon_photoframe1.png",
                          height: height > 600.0 ?230:190,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  //padding: const EdgeInsets.only(top: height > 600.0 ?97:67),
                  margin: EdgeInsets.only(top: height > 600.0 ?65:49),
                  child: Image.asset("images/icon_cameranew.png",
                      width:height > 600.0 ?170.0:150, height: height > 600.0 ?300.0:240, fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        ),
      ),
    );*/
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('images/bg.jpeg'), fit: BoxFit.cover),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.6),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 55.0, bottom: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(15.0),
                                child: Image.asset(
                                  'images/om2.png',
                                  fit: BoxFit.fill,
                                  width: 150,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Container(
                                  height: 75,
                                  child: TextFormField(
                                    controller: edtMobile,
                                    scrollPadding: EdgeInsets.all(0),
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: new OutlineInputBorder(
                                          borderSide:
                                              new BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        fillColor:
                                            Colors.white.withOpacity(0.25),
                                        prefixIcon: Icon(
                                          Icons.phone_android,
                                          color: Colors.white,
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                        hintText: "Mobile No"),
                                    maxLength: 10,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(9.0)),
                                  color: cnst.appPrimaryMaterialColor,
                                  //minWidth: MediaQuery.of(context).size.width - 20,
                                  onPressed: () {
                                    //if (isLoading == false) this.SaveOffer();
                                    //Navigator.pushReplacementNamed(context, '/Dashboard');
                                    //Navigator.pushReplacementNamed(context, '/OtpVerification');
                                    checkLogin();
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '_________________________________________________________________',
                                          maxLines: 1,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        "                    ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '_________________________________________________________________',
                                          maxLines: 1,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/SignUpGuest');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Guest ?',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          Text(
                                            'SIGN UP',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: cnst
                                                    .appPrimaryMaterialColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                /*Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'images/earth.png',
                                        color: Colors.white,
                                        width: 15,
                                        height: 15,
                                      ),
                                      Text(
                                        '  Inquiry@thestudioom.com',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),*/
                                /*Padding(
                                  padding:
                                      const EdgeInsets.only(top: 13, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //Image.asset('images/earth.png',color: Colors.white,width: 15,height: 15,),
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Text(
                                        '+91 74090022113',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),*/
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                /*Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 55.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: Container(
                            height: 75,
                            child: TextFormField(
                              controller: edtMobile,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: Colors.white.withOpacity(0.25),
                                  prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: Colors.white,
                                  ),
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  hintText: "Mobile No"),
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 10),
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(9.0)),
                            color: cnst.appPrimaryMaterialColor,
                            minWidth: MediaQuery.of(context).size.width - 20,
                            onPressed: () {
                              //if (isLoading == false) this.SaveOffer();
                              //Navigator.pushReplacementNamed(context, '/Dashboard');
                              //Navigator.pushReplacementNamed(context, '/OtpVerification');
                              */ /*if (isLoading == false) {
                                checkLogin();
                              }*/ /*
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30,bottom: 30),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '_________________________________________________________________',
                                  maxLines: 1,style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Text(
                                "                    ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Expanded(
                                child: Text(
                                  '_________________________________________________________________',
                                  maxLines: 1,style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0,bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('images/earth.png',color: Colors.white,width: 15,height: 15,),
                              Text('  Inquiry@thestudioom.com',style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13,bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Image.asset('images/earth.png',color: Colors.white,width: 15,height: 15,),
                              Icon(Icons.call,color: Colors.white,size: 20,),
                              Text('+91 74090022113',style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),*/
                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30,bottom: 30),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '_________________________________________________________________',
                              maxLines: 1,style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Text(
                            "                    ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Expanded(
                            child: Text(
                              '_________________________________________________________________',
                              maxLines: 1,style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
