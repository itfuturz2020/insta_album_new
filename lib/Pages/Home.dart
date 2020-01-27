import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/AlbumComponent.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class Home extends StatefulWidget {

  String galleryId, galleryName,IsSelectionDone;

  Home(this.galleryId, this.galleryName,this.IsSelectionDone);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    print("${widget.IsSelectionDone}");
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Photo Cloud"),
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


  updateGalleryStatus(String status) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.UpdateGallrySelection(widget.galleryId, status);
        res.then((data) async {
          pr.hide();
          if (data.Data == "1") {
            setState(() {
              if(status=="true"){
                widget.IsSelectionDone = "true";
              }else {
                widget.IsSelectionDone = "false";
              }
            });
          } else {
            showMsg("Something Went Wrong Please Try Again.");
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.galleryName}"),
        actions: <Widget>[
          widget.IsSelectionDone == "true"
              ? Padding(
              padding: const EdgeInsets.all(7),
              child: GestureDetector(
                onTap: () {
                  updateGalleryStatus("false");
                },
                child: Container(
                  //width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 0, bottom: 0),
                      child: Center(
                        child: Text(
                          "Cancel\nSelection",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
              ))
              : Padding(
              padding: const EdgeInsets.all(7),
              child: GestureDetector(
                onTap: () {
                  updateGalleryStatus("true");
                },
                child: Container(
                  //width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 0, bottom: 0),
                      child: Center(
                        child: Text(
                          "Complate\nSelection",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
              ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List>(
          future: Services.GetCustomerAlbumList(widget.galleryId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.data!=null && snapshot.data.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AlbumComponent(snapshot.data[index]);
                        },
                      )
                    : NoDataComponent()
                : LoadinComponent();
          },
        ),
      ),
    );
  }
}
