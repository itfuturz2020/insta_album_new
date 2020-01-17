import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:insta_album_new/Pages/Home.dart';
import 'package:insta_album_new/Screen/AlbumAllImages.dart';
import 'package:insta_album_new/Screen/Dashboard.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Screen/PendingList.dart';
import 'package:insta_album_new/Screen/SelectedList.dart';

class SelectedAlbum extends StatefulWidget {
  String albumId,albumName,totalImg;

  SelectedAlbum({this.albumId,this.albumName,this.totalImg});



  @override
  _SelectedAlbumState createState() => _SelectedAlbumState();
}

class _SelectedAlbumState extends State<SelectedAlbum> {
  List<MenuClassOne> _allServices = MenuClassOne.allServiceslist("0","0","0");
  List albumData = new List();
  ProgressDialog pr;
  String allCount="",selectedCount="",pendingCount="";
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
    getAlbumData();
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

  getAlbumData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.GetAlbumData(widget.albumId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              albumData = data;
              //final String allCount="",selectedCount="",pendingCount="";
              selectedCount=data[0]["SelectedPhotoCount"].toString();

              allCount=data[0]["NoOfPhoto"].toString();

              pendingCount=(int.parse(data[0]["NoOfPhoto"].toString())-int.parse(data[0]["SelectedPhotoCount"].toString())).toString();

              final List<MenuClassOne> _allServices1 = MenuClassOne.allServiceslist(allCount,selectedCount,pendingCount);
              _allServices=_allServices1;
            });
          } else {
            pr.hide();
            showMsg("Try Again.");
            setState(() {
              albumData.clear();
            });
          }
        }, onError: (e) {
          pr.hide();
          print("Error : on Login Call $e");
          //showMsg("$e");
          setState(() {
            albumData.clear();
          });
        });
      } else {
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  Widget _getServiceMenu(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (_allServices[index].title.toString() == "All Images") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AlbumAllImages(
                    albumId: widget.albumId,albumName: widget.albumName,
                      totalImg:widget.totalImg
                      )));
        } else if (_allServices[index].title.toString() == "Selected List") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectedList(
                    albumId: widget.albumId,albumName: widget.albumName,
                      totalImg:widget.totalImg
                  )));
        } else if (_allServices[index].title.toString() == "Pending List") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PendingList(
                    albumId: widget.albumId,albumName: widget.albumName,
                      totalImg:widget.totalImg
                  )));
        }
      },
      child: Card(
        elevation: 2,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 4,right: 4),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "images/" + _allServices[index].Iconpath,
                    width: 37,
                    height: 37,
                    color: cnst.appPrimaryMaterialColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      _allServices[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "${_allServices[index].label}${_allServices[index].allCount}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cnst.appPrimaryMaterialColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          "${widget.albumName}",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          child: albumData.length > 0
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlbumAllImages(
                                      albumId: widget.albumId,albumName: widget.albumName,
                                      totalImg:widget.totalImg
                                  )));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              /*child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/9/9c/Hrithik_at_Rado_launch.jpg',
                                //height: 150,
                                fit: BoxFit.fill,
                              ),*/
                              child: albumData[0]["Photo"] != null
                                  ? FadeInImage.assetNetwork(
                                placeholder: 'images/icon_events.jpg',
                                image:
                                "${cnst.ImgUrl}${albumData[0]["Photo"]}",
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                color: Colors.grey[100],
                              ),
                            ),
                            Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, 0.5),
                                    Color.fromRGBO(0, 0, 0, 0.5),
                                    Color.fromRGBO(0, 0, 0, 0.5),
                                    Color.fromRGBO(0, 0, 0, 0.5)
                                  ],
                                ),
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '${albumData[0]["Name"]}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        /*Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Text(
                                            '${albumData[0]["SelectedPhotoCount"]}/${albumData[0]["NoOfPhoto"]}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Expiry Date : ${albumData[0]["ExpDate"].substring(8, 10)} - '
                                      "${(((albumData[0]["ExpDate"].substring(5, 7)).toString()))} - ${albumData[0]["ExpDate"].substring(0, 4)}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            )*/
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, left: 6.0, right: 6.0, bottom: 10),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _allServices.length,
                            itemBuilder: _getServiceMenu,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      //(370),
                                      (MediaQuery.of(context).size.height / 1.5),
                            )),
                      ),
                    ],
                  ),
                )
              : NoDataComponent(),
        ),
      ),
    );
  }
}

class MenuClassOne {
  final String Iconpath;
  final String title;
  final String allCount;
  final String label;

  MenuClassOne({this.Iconpath, this.title,this.allCount,this.label});

  static List<MenuClassOne> allServiceslist(final String allcount,final String selectedCount,final String pendingCount) {
    var Vendorlist = new List<MenuClassOne>();

    Vendorlist.add(
        new MenuClassOne(Iconpath: "icon_allimages.png", title: "All Images",allCount: allcount,label: "Total = "));
    Vendorlist.add(new MenuClassOne(
        Iconpath: "icon_selected.png", title: "Selected List",allCount: selectedCount,label: "Selected = "));
    Vendorlist.add(
        new MenuClassOne(Iconpath: "icon_pending.png", title: "Pending List",allCount: pendingCount,label: "Pending = "));

    return Vendorlist;
  }
}
