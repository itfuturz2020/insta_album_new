import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/ClassList.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Common/Services.dart';

class BookAppointment extends StatefulWidget {
  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  DateTime _dateTime;
  String _format = 'yyyy-MMMM-dd', timeFlag = "";
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  bool isLoading = false;
  TextEditingController txtDesc = new TextEditingController();

  List<timeClass> _timeClassList = [];
  timeClass _timeClass;

  ProgressDialog pr;

  @override
  void initState() {
    _dateTime = DateTime.now();
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
    //_getTimeSlots("${_dateTime.toString().substring(8, 10)}-${_dateTime.toString().substring(5, 7)}-${_dateTime.toString().substring(0, 4)}");
    _getTimeSlots("${_dateTime.toString()}");
  }

  _getTimeSlots(String date) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getTimeSlots(date);
        pr.show();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _timeClassList = data;
            });
            pr.hide();
          } else {
            pr.hide();
            setState(() {
              _timeClassList = data;
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _bookAppointment() async {
    if (txtDesc.text != null && _timeClass != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String StudioId = preferences.getString(Session.StudioId);
          String CustomerID = preferences.getString(Session.CustomerId);
          var data = {
            "Id": 0,
            "AppointmentSlotId": "${_timeClass.id}",
            "StudioId": "$StudioId",
            "Date": _dateTime.toString(),
            "CustomerId": "$CustomerID",
            "Description": txtDesc.text,
          };
          print(data);
          Services.BookAppointment(data).then((data) async {
            pr.hide();
            if (data.Data == "1") {
              Fluttertoast.showToast(
                  msg: "Appointment Booked Successfully",
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_SHORT);
              //Navigator.pushReplacementNamed(context, "/Dashboard");
              Navigator.of(context).pop();
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
    } else
      showMsg("Please Fill All Details");
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
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

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
        cancel: Text('cancel', style: TextStyle(color: Colors.cyan)),
      ),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
        _getTimeSlots("${_dateTime.toString()}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //Navigator.pushReplacementNamed(context, "/Dashboard");
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Book Appointment"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                //Navigator.pushReplacementNamed(context, "/Dashboard");
                Navigator.pop(context);
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showDatePicker();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "${_dateTime.toString().substring(8, 10)}-${_dateTime.toString().substring(5, 7)}-${_dateTime.toString().substring(0, 4)}",
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                child: InputDecorator(
                  decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        //borderSide: new BorderSide(),
                      )),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<timeClass>(
                    hint: _timeClassList != null &&
                            _timeClassList != "" &&
                            _timeClassList.length > 0
                        ? Text("Select Prefered Time")
                        : Text(
                            "Time Data Not Found",
                            style: TextStyle(fontSize: 14),
                          ),
                    value: _timeClass,
                    onChanged: (val) {
                      setState(() {
                        if (val.IsBooked.toString() != "1") {
                          _timeClass = val;
                          timeFlag = val.time;
                        }else{
                          Fluttertoast.showToast(msg: "Time slot already booked.",gravity: ToastGravity.TOP);
                        }
                      });
                    },
                    items: _timeClassList.map((timeClass time) {
                      return new DropdownMenuItem<timeClass>(
                        value: time,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              time.time,
                              style: TextStyle(color:time.IsBooked.toString() == "1"?Colors.red :Colors.black),
                            ),
                            time.IsBooked.toString() == "1"
                                ? Text(
                                    'Booked',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    }).toList(),
                  )),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 6)),
              Container(
                child: TextFormField(
                  controller: txtDesc,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.sms_failed,
                      ),
                      hintText: "Description"),
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                margin: EdgeInsets.only(top: 20),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  color: cnst.appPrimaryMaterialColor,
                  onPressed: () {
                    _bookAppointment();
                  },
                  child: Text(
                    "Book Appointment",
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
      ),
    );
  }
}
