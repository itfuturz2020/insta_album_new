import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Common/Services.dart';

class SignUpGuest extends StatefulWidget {
  @override
  _SignUpGuestState createState() => _SignUpGuestState();
}

class _SignUpGuestState extends State<SignUpGuest> {
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobileNo = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  List _selectedContact = [];

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

  _addCustomer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        _selectedContact.clear();
        _selectedContact.add({
          "Id": 0,
          "Name": edtName.text,
          "Mobile": edtMobileNo.text,
          "Email": edtEmail.text,
          "StudioId": cnst.Studio_Id.toString(),
          "Type": "Guest",
        });
        Services.GuestSignUp(_selectedContact).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            Fluttertoast.showToast(
                msg: "Registered Successfully",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushReplacementNamed(context, "/Login");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
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
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
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
                      left: 20, right: 20, top:05.0, bottom: 1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0,bottom: 30),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Container(
                            height: 75,
                            child: TextFormField(
                              controller: edtName,
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
                                    Icons.account_box,
                                    color: Colors.white,
                                  ),
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  hintText: "Name"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            height: 75,
                            child: TextFormField(
                              controller: edtMobileNo,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            height: 75,
                            child: TextFormField(
                              controller: edtEmail,
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
                                    Icons.mail,
                                    color: Colors.white,
                                  ),
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  hintText: "Email Id"),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          margin: EdgeInsets.only(top: 20),
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
                              if (edtName.text != "" && edtName.text != null) {
                                if (edtMobileNo.text != "" &&
                                    edtMobileNo.text != null) {
                                  if (edtMobileNo.text.length == 10) {
                                    if(edtEmail.text!=""){
                                      _addCustomer();
                                    }else{
                                      showMsg("Enter Customer Email");
                                    }
                                  } else {
                                    showMsg("Enter Customer Valid Mobile Number");
                                  }
                                } else {
                                  showMsg("Enter Customer Mobile Number");
                                }
                              } else {
                                showMsg("Enter Customer Name");
                              }
                            },
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/Login');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Already Register ?',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: cnst.appPrimaryMaterialColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
