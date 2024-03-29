import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Screen/SelectedPhotoShow.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/AllAlbumComponent.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:insta_album_new/Screen/ImageView.dart';
import 'package:insta_album_new/Screen/SelectedAlbum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumAllImages extends StatefulWidget {
  String albumId, albumName, totalImg;

  AlbumAllImages({this.albumId, this.albumName, this.totalImg});

  @override
  _AlbumAllImagesState createState() => _AlbumAllImagesState();
}

class _AlbumAllImagesState extends State<AlbumAllImages> {
  List albumData = new List();
  List selectedData = new List();
  List selectedPhone = new List();

  bool isSaveButton = false;
  ProgressDialog pr;
  String selectedCount = "0";

  final List<String> moreMenus = <String>["Download", "Share", "Save Selected"];
  String selectedMoreMenu = "";

  String SelectedPin = "", PinSelection = "";

  ProgressDialog pr1;
  TextEditingController edtPIN = new TextEditingController();

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
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        SelectedPin = preferences.getString(Session.SelectedPin);
        PinSelection = preferences.getString(Session.PinSelection);
      });
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

  setNewArrayList(String Id, String isSelected, String ImageUrl) {
    bool ischeck = false;
    bool ischeckimage = false;

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

    if (selectedPhone.length > 0) {
      for (int i = 0; i < selectedPhone.length; i++) {
        if (selectedData[i]["Id"].toString() == Id) {
          setState(() {
            ischeckimage = true;
            selectedPhone.removeAt(i);
          });
        }
      }
      if (ischeckimage == false) {
        if (isSelected == "true") {
          var data1 = {
            'Id': Id,
            'ImageUrl': ImageUrl,
          };
          selectedPhone.add(data1);
        }
      }
    } else {
      if (isSelected == "true") {
        var data1 = {
          'Id': Id,
          'ImageUrl': ImageUrl,
        };
        selectedPhone.add(data1);
      }
    }
    //pr1.hide();
    setState(() {});
    print("Select Image = ${selectedPhone.toString()}");
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

  /*Widget getImage(BuildContext context, int index) {
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
  }*/

  downloadAll() async {
    pr1.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.PinSelection, "true");
    for (int i = 0; i < selectedPhone.length; i++) {
      String filename = "";

      String path =
          "${cnst.ImgUrl}${selectedPhone[i]["ImageUrl"].toString().replaceAll(" ", "%20")}";
      try {
        Platform.isIOS
            ? await GallerySaver.saveImage(path).then((bool success) {
                print("Success = ${success}");
                Fluttertoast.showToast(
                    msg: "Download Complete",
                    gravity: ToastGravity.TOP,
                    toastLength: Toast.LENGTH_SHORT);
              })
            : await downloadAndroid(path);
      } catch (e) {
        print(e);
      }
    }
    pr1.hide();
  }

  downloadAndroid(String path) async {
    var response = await Dio()
        .get("${path}", options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Fluttertoast.showToast(
        msg: "Download Complete",
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT);
  }

  shareFile() async {
    pr1.show();
    String filename = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.PinSelection, "true");
    //var imagedata = {};
    Map<String, List<int>> imagedata = {};

    for (int i = 0; i < selectedPhone.length; i++) {
      filename = selectedPhone[i]["ImageUrl"].split('/').last;
      var request = await HttpClient().getUrl(Uri.parse(cnst.ImgUrl +
          selectedPhone[i]["ImageUrl"].toString().replaceAll(" ", "%20")));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);

      imagedata["${filename}"] = bytes;
    }
    pr1.hide();
    await Share.files('esys images', imagedata, '*/*', text: '');
  }

  _onMoreMenuSelection(index) {
    switch (index) {
      case 'Download':
        if (selectedPhone.length > 0) {
          if (SelectedPin != "" &&
              (PinSelection == "false" ||
                  PinSelection == "" ||
                  PinSelection.toString() == "null")) {
            _openDialog("Download");
          } else {
            pr1 = new ProgressDialog(context, type: ProgressDialogType.Normal);
            pr1.style(
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
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600));
            downloadAll();
          }
        } else {
          Fluttertoast.showToast(
              msg: "No Image Selected.",
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        }
        break;
      case 'Share':
        if (selectedPhone.length > 0) {
          if (SelectedPin != "" &&
              (PinSelection == "false" ||
                  PinSelection == "" ||
                  PinSelection.toString() == "null")) {
            _openDialog("Share");
          } else {
            pr1 = new ProgressDialog(context, type: ProgressDialogType.Normal);
            pr1.style(
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
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600));
            shareFile();
          }
        } else {
          Fluttertoast.showToast(
              msg: "No Image Selected.",
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        }
        break;
      case 'Save Selected':
        pr1 = new ProgressDialog(context, type: ProgressDialogType.Normal);
        pr1.style(
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
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600));
        sendSelectImage();
        break;
    }
  }

  _openDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("PICTIK"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 75,
                child: TextFormField(
                  controller: edtPIN,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintText: "Enter PIN"),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              new Text("Are You Sure You Want To Download/Share Images ?"),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
                if (edtPIN.text == SelectedPin) {
                  Navigator.pop(context);
                  setState(() {
                    PinSelection = "true";

                  });
                  pr1 = new ProgressDialog(context,
                      type: ProgressDialogType.Normal);
                  pr1.style(
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
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600));

                  if (type == "Share") {
                    shareFile();
                  } else {
                    downloadAll();
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Enter Valid PIN...",
                      textColor: cnst.appPrimaryMaterialColor[700],
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_SHORT);
                }
                print("PIN: ${edtPIN.text}");
              },
            ),
          ],
        );
      },
    );
  }

  getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      SelectedPin = preferences.getString(Session.SelectedPin);
      PinSelection = preferences.getString(Session.PinSelection);
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
          IconButton(
              onPressed: () {
                //selectedPhone
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectedPhotoShow(allPhotos: albumData)));
              },
              icon: Icon(Icons.play_circle_outline,size: 30,)),
          selectedData.length > 0
              ? PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                        child: const Text('Download'), value: 'Download'),
                    new PopupMenuItem<String>(
                        child: const Text('Share'), value: 'Share'),
                    new PopupMenuItem<String>(
                        child: const Text('Save Selected'),
                        value: 'Save Selected'),
                  ],
                  onSelected: (index) {
                    //print("Selected Menu:  ${index}");
                    _onMoreMenuSelection(index);
                  },
                )
              : Container(),
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
                  child: Row(
                    children: <Widget>[
                      Expanded(
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
                      selectedPhone.length > 0
                          ? Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (selectedPhone.length > 0) {
                                      if (SelectedPin != "" &&
                                          (PinSelection == "false" ||
                                              PinSelection == "" ||
                                              PinSelection.toString() ==
                                                  "null")) {
                                        _openDialog("Download");
                                      } else {
                                        pr1 = new ProgressDialog(context,
                                            type: ProgressDialogType.Normal);
                                        pr1.style(
                                            message: "Please Wait",
                                            borderRadius: 10.0,
                                            progressWidget: Container(
                                              padding: EdgeInsets.all(15),
                                              child: CircularProgressIndicator(
                                                backgroundColor: cnst
                                                    .appPrimaryMaterialColor,
                                              ),
                                            ),
                                            elevation: 10.0,
                                            insetAnimCurve: Curves.easeInOut,
                                            messageTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600));
                                        downloadAll();
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "No Image Selected.",
                                          gravity: ToastGravity.TOP,
                                          toastLength: Toast.LENGTH_SHORT);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cnst.appPrimaryMaterialColor,
                                        border: Border.all(
                                            color: cnst.appPrimaryMaterialColor,
                                            width: 2)),
                                    child: Icon(
                                      Icons.file_download,
                                      size: 17,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (selectedPhone.length > 0) {
                                      if (SelectedPin != "" &&
                                          (PinSelection == "false" ||
                                              PinSelection == "" ||
                                              PinSelection.toString() ==
                                                  "null")) {
                                        _openDialog("Share");
                                      } else {
                                        pr1 = new ProgressDialog(context,
                                            type: ProgressDialogType.Normal);
                                        pr1.style(
                                            message: "Please Wait",
                                            borderRadius: 10.0,
                                            progressWidget: Container(
                                              padding: EdgeInsets.all(15),
                                              child: CircularProgressIndicator(
                                                backgroundColor: cnst
                                                    .appPrimaryMaterialColor,
                                              ),
                                            ),
                                            elevation: 10.0,
                                            insetAnimCurve: Curves.easeInOut,
                                            messageTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600));
                                        shareFile();
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "No Image Selected.",
                                          gravity: ToastGravity.TOP,
                                          toastLength: Toast.LENGTH_SHORT);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cnst.appPrimaryMaterialColor,
                                        border: Border.all(
                                            color: cnst.appPrimaryMaterialColor,
                                            width: 2)),
                                    child: Icon(
                                      Icons.share,
                                      size: 17,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
                Expanded(
                  child: albumData.length != 0 && albumData != null
                      ? StaggeredGridView.countBuilder(
                          padding:
                              const EdgeInsets.only(left: 3, right: 3, top: 5),
                          crossAxisCount: 4,
                          itemCount: albumData.length,
                          addRepaintBoundaries: false,
                          itemBuilder: (BuildContext context, int index) {
                            return AllAlbumComponent(albumData[index], index,
                                (action, Id, ImageUrl) {
                              if (action.toString() == "Show") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                            albumData: albumData,
                                            albumIndex: index,
                                            onChange: (action) {
                                              if(action=="getData"){
                                                getLocalData();
                                              }
                                            })));
                              } else if (action.toString() == "Remove") {
                                pr1 = new ProgressDialog(context,
                                    type: ProgressDialogType.Normal);
                                pr1.style(
                                    message: "Please Wait",
                                    borderRadius: 10.0,
                                    progressWidget: Container(
                                      padding: EdgeInsets.all(15),
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            cnst.appPrimaryMaterialColor,
                                      ),
                                    ),
                                    elevation: 10.0,
                                    insetAnimCurve: Curves.easeInOut,
                                    messageTextStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600));
                                int count = int.parse(selectedCount);
                                count = count - 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "false", ImageUrl);
                              } else {
                                int count = int.parse(selectedCount);
                                count = count + 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "true", ImageUrl);
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
