import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class SelectSound extends StatefulWidget {
  @override
  _SelectSoundState createState() => _SelectSoundState();
}

class _SelectSoundState extends State<SelectSound> {
  bool isLoading = true;
  List soundData = [];
  String selectedMusic = "";
  @override
  void initState() {
    _getMusic();
  }

  _getMusic() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetSoundData();
        isLoading = true;
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              soundData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Background Music",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: isLoading
          ? LoadinComponent()
          : soundData.length > 0
              ? ListView.builder(
                  itemCount: soundData.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      Column(
                        children: <Widget>[
                          ListTile(
                            leading: Radio(
                              activeColor: cnst.appPrimaryMaterialColor,
                              value: '${soundData[index]["Id"]}',
                              groupValue: selectedMusic,
                              //activeColor: Colors.green,
                              onChanged: (val) {
                                setState(() {
                                  selectedMusic = val;
                                });
                                print("Radio $val");
                              },
                            ),
                            title: Text(soundData[index]["Sound"]),
                          ),
                          Divider(
                            thickness: 2,
                          )
                        ],
                      );
                  },
                )
              : NoDataComponent(),
    );
  }
}
