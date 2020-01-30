import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:insta_album_new/Components/PhotoCommentConponent.dart';
import 'package:path_provider/path_provider.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedAlbumComponent extends StatefulWidget {
  var albumData;
  int index;
  Function onChange;
  String SelectedPin;

  SelectedAlbumComponent(this.albumData, this.index, this.onChange);

  @override
  _SelectedAlbumComponentState createState() => _SelectedAlbumComponentState();
}

class _SelectedAlbumComponentState extends State<SelectedAlbumComponent> {
  bool downloading = false;

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
      print("${dir.path}/${file[3].toString()}");
      await dio.download(
          "${cnst.ImgUrl}${url.replaceAll(" ", "%20")}",
          "${dir.path}/${file[3].toString()}", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        setState(() {
          downloading = true;
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
    });
  }

  shareFile(String ImgUrl) async {
    ImgUrl=ImgUrl.replaceAll(" ", "%20");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient().getUrl(Uri.parse("${ImgUrl}"));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files('ESYS AMLOG', {
        'esys.png': bytes,
      }, 'image/jpg');
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => BottomSheet(
        widget.albumData,
            (action) {},
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChange("Show", widget.index);
      },
      child: Container(
        padding: EdgeInsets.all(0),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),
            side: BorderSide(width: 0.10, color: cnst.appPrimaryMaterialColor),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            //padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: widget.albumData["Photo"] != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/icon_events.jpg',
                          image:
                              "${cnst.ImgUrl}${widget.albumData["PhotoThumb"]}",
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.blue[100],
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (widget.albumData["IsSelected"].toString() == "true") {
                              setState(() {
                                widget.albumData["IsSelected"] = "false";
                              });
                              widget.onChange(
                                  "Remove", widget.albumData["Id"].toString());
                            } else {
                              setState(() {
                                widget.albumData["IsSelected"] = "true";
                              });
                              widget.onChange("Add", widget.albumData["Id"].toString());
                            }
                          },
                          child: widget.albumData["IsSelected"].toString() == "true"
                              ? Container(
                            margin: EdgeInsets.all(5),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cnst.appPrimaryMaterialColor,
                                border: Border.all(
                                    color: cnst.appPrimaryMaterialColor,
                                    width: 2)),
                            child: Icon(Icons.check),
                          )
                              : Container(
                            margin: EdgeInsets.all(5),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.6),
                                border:
                                Border.all(color: Colors.white, width: 2)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _settingModalBottomSheet(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 17,
                            ),
                          ),
                        ),
                        /*Platform.isIOS ?
                            Container():
                        GestureDetector(
                          onTap: () {
                            _downloadFile(widget.albumData["Photo"]);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: downloading == true
                                ? Container(
                              child: CircularProgressIndicator(),
                            )
                                : Icon(
                              Icons.file_download,
                              size: 17,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            shareFile("${cnst.ImgUrl}${widget.albumData["Photo"].toString()}");

                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: Icon(
                              Icons.share,
                              size: 17,
                            ),
                          ),
                        ),*/
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  Function onchange;
  var Data;

  BottomSheet(this.Data, this.onchange);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  String paymentMethod = "";
  String _Fromtime = "From Time";
  String _Totime = "To Time";
  TextEditingController edtComment = new TextEditingController();

  DateTime FromDate, ToDate;
  List CommentList = new List();
  ProgressDialog pr;
  bool IsLoading = true;

  String CustomerId="";

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

    // TODO: implement initState
    super.initState();
    getCommentData();
  }

  getCommentData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      CustomerId = prefs.getString(Session.CustomerId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          IsLoading = true;
        });
        Future res = Services.GetImageComment(widget.Data["Id"].toString());
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              CommentList = data;
              IsLoading = false;
            });
          } else {
            pr.hide();
            setState(() {
              CommentList.clear();
              IsLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          pr.hide();
          setState(() {
            IsLoading = false;
          });
          print("Error : on Login Call $e");
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

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  //send More Info to server
  sendRequestBookingFn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String CustomerId = prefs.getString(Session.CustomerId);

        var data = {
          'Id': "0",
          'CustomerId': CustomerId,
          'AlbumPhotoId': widget.Data["Id"].toString(),
          'Comment': edtComment.text.toString().trim(),
        };
        Services.AddComment(data).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            Navigator.pop(context);
            showMsg("Comment Added Successfully");
          } else {
            pr.hide();
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

  deleteComment(String id,int index) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res =
        Services.DeleteComment(id);
        res.then((data) async {
          if (data.Data.toString() == "1") {
            setState(() {
              pr.hide();
              CommentList.removeAt(index);
              //widget.onChange("cancel");
            });
            showMsg("Comment Deleted Successfully");
          } else {
            pr.hide();
            showMsg(data.Message);
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        //height: 500,
        padding: EdgeInsets.only(
            top: 30, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 5),
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ),
            Expanded(
                child: IsLoading
                    ? LoadinComponent()
                    : CommentList.length > 0
                    ? ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: CommentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PhotoCommentConponent(
                        CommentList[index],CustomerId, (action,id) {
                      if(action=="delete"){
                        deleteComment(id,index);
                      }
                    });
                  },
                )
                    : NoDataComponent()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 60,
                    child: TextFormField(
                      controller: edtComment,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          fillColor: Colors.black.withOpacity(0.1),
                          hintStyle:
                          TextStyle(fontSize: 15, color: Colors.black),
                          hintText: "Enter Comment"),
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 45,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100)),
                    color: cnst.appPrimaryMaterialColor,
                    onPressed: () {
                      if (edtComment.text != "") {
                        sendRequestBookingFn();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Enter Comment",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_SHORT);
                      }
                    },
                    child: Icon(
                      Icons.send,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}