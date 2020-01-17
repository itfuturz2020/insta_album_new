import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/GuestPortfolioImagesComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:insta_album_new/Screen/PortfolioImageView.dart';

class GuestportfolioImages extends StatefulWidget {
  String galleryId, galleryName;

  GuestportfolioImages(this.galleryId, this.galleryName);

  @override
  _GuestportfolioImagesState createState() => _GuestportfolioImagesState();
}

class _GuestportfolioImagesState extends State<GuestportfolioImages> {
  ProgressDialog pr;
  List albumData = new List();

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
    getAlbumAllData();
  }

  getAlbumAllData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.GetCategoryAlbumAllData(widget.galleryId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              albumData = data;
            });
          } else {
            pr.hide();
            setState(() {
              albumData.clear();
            });
          }
        }, onError: (e) {
          pr.hide();
          print("Error : on Login Call $e");
          setState(() {
            albumData.clear();
          });
          //showMsg("$e");
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
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: albumData.length != 0 && albumData != null
            ? StaggeredGridView.countBuilder(
                padding: const EdgeInsets.only(left: 3, right: 3, top: 5),
                crossAxisCount: 4,
                itemCount: albumData.length,
                itemBuilder: (BuildContext context, int index) {
                  return GuestPortfolioImagesComponent(albumData[index], index,
                      (action, Id) {
                    if (action.toString() == "Show") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PortfolioImageView(
                                  albumData: albumData, albumIndex: index)));
                    }
                  });
                },
                staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              )
            : NoDataComponent(),
      ),
    );
  }
}
