import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/AllAlbumComponent.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:insta_album_new/Screen/ImageView.dart';
import 'package:insta_album_new/Screen/SelectedAlbum.dart';

class AlbumAllImages extends StatefulWidget {
  String albumId, albumName, totalImg;

  AlbumAllImages({this.albumId, this.albumName, this.totalImg});

  @override
  _AlbumAllImagesState createState() => _AlbumAllImagesState();
}

class _AlbumAllImagesState extends State<AlbumAllImages> {
  List albumData = new List();
  List selectedData = new List();

  bool isSaveButton = false;
  ProgressDialog pr;
  String selectedCount = "0";

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

  getAlbumAllData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.GetAlbumAllData(widget.albumId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              albumData = data[0]["PhotoList"];
            });
            setState(() {
              selectedCount = data[0]["SelectedCount"].toString();
            });
          } else {
            pr.hide();
            //showMsg("Try Again.");
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

  setNewArrayList(String Id, String isSelected) {
    bool ischeck = false;
    if (selectedData.length > 0) {
      for (int i = 0; i < selectedData.length; i++) {
        if (selectedData[i]["Id"].toString() == Id) {
          setState(() {
            ischeck = true;
            selectedData[i]["IsSelected"] = isSelected;
          });
        }
        /*else {
          var data = {
            'Id': Id,
            'IsSelected': isSelected,
          };
          selectedData.add(data);
        }*/
      }
      if (ischeck == false) {
        var data = {
          'Id': Id,
          'IsSelected': isSelected,
        };
        selectedData.add(data);
      }
    } else {
      var data = {
        'Id': Id,
        'IsSelected': isSelected,
      };
      selectedData.add(data);
    }
    print(selectedData.toString());
  }

  signUpDone(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Okay",
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

  sendSelectImage() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();

        Services.UploadSelectedImage(selectedData).then((data) async {
          if (data.Data == "1") {
            pr.hide();
            setState(() {
              signUpDone("Data Saved Successfully.");
              selectedData.clear();
            });
          } else {
            pr.hide();
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  Widget getImage(BuildContext context, int index) {
    return AllAlbumComponent(albumData[index], index, (action, Id) {
      if (action.toString() == "Show") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ImageView(albumData: albumData, albumIndex: index)));
      } else if (action.toString() == "Remove") {
        int count = int.parse(selectedCount);
        count = count - 1;
        setState(() {
          selectedCount = count.toString();
        });
        setNewArrayList(Id, "false");
      } else {
        int count = int.parse(selectedCount);
        count = count + 1;
        setState(() {
          selectedCount = count.toString();
        });
        setNewArrayList(Id, "true");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: cnst.appPrimaryMaterialColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectedAlbum(
                        albumId: widget.albumId,
                        albumName: widget.albumName,
                        totalImg: widget.totalImg)));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          selectedData.length > 0
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      sendSelectImage();
                    },
                    child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3, right: 3, top: 2, bottom: 2),
                          child: Center(
                            child: Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  ))
              : Container(),
          /*GestureDetector(
            onTap: (){
              shareFile();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.share,size: 25,),
            ),
          )*/
        ],
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          "${widget.albumName}",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectedAlbum(
                      albumId: widget.albumId,
                      albumName: widget.albumName,
                      totalImg: widget.totalImg)));
        },
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(0),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "${"Selected Images : "}${selectedCount} / ${widget.totalImg}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Expanded(
                  child: albumData.length != 0 && albumData != null
                      /*? GridView.builder(
                          padding: EdgeInsets.only(top: 5),
                          itemCount: albumData.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: MediaQuery.of(context)
                                    .size
                                    .width /
                                (MediaQuery.of(context).size.height / 1.7),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return AllAlbumComponent(albumData[index], index,
                                (action, Id) {
                              if (action.toString() == "Show") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                            albumData: albumData,
                                            albumIndex: index)));
                              } else if (action.toString() == "Remove") {
                                int count = int.parse(selectedCount);
                                count = count - 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "false");
                              } else {
                                int count = int.parse(selectedCount);
                                count = count + 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "true");
                              }
                            });
                          })*/
                      ? StaggeredGridView.countBuilder(
                          padding:
                              const EdgeInsets.only(left: 3, right: 3, top: 5),
                          crossAxisCount: 4,
                          itemCount: albumData.length,
                          addRepaintBoundaries: false,
                          itemBuilder: (BuildContext context, int index) {
                            return AllAlbumComponent(albumData[index], index,
                                (action, Id) {
                              if (action.toString() == "Show") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                            albumData: albumData,
                                            albumIndex: index)));
                              } else if (action.toString() == "Remove") {
                                int count = int.parse(selectedCount);
                                count = count - 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "false");
                              } else {
                                int count = int.parse(selectedCount);
                                count = count + 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "true");
                              }
                            });
                          },
                          staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                        )
                      : NoDataComponent(),
                ),
              ],
            )),
      ),
    );
  }
}
