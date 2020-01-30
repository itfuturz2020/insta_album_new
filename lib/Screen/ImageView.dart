import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Screen/AlbumAllImages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageView extends StatefulWidget {
  List albumData;
  int albumIndex;
  String TotalImg;
  Function onChange;

  ImageView({this.albumData, this.albumIndex,this.onChange});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool downloading = false;

  ProgressDialog pr;
  String SelectedPin = "", PinSelection = "";

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
    getLocalData();
    super.initState();
  }
  getLocalData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      SelectedPin = preferences.getString(Session.SelectedPin);
      PinSelection = preferences.getString(Session.PinSelection);
    });
  }

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir;
      dir = await getExternalStorageDirectory();
      print("${dir.path}/${file[3].toString()}");
      await dio.download("${cnst.ImgUrl}${url.replaceAll(" ", "%20")}",
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.PinSelection, "true");
    widget.onChange("getData");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient().getUrl(Uri.parse(ImgUrl));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files(
          'ESYS AMLOG',
          {
            'esys.png': bytes,
          },
          'image/jpg');
    }
  }

  _saveNetworkImage(String url) async {
    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.PinSelection, "true");
    widget.onChange("getData");
    Platform.isIOS
        ? await GallerySaver.saveImage(url).then((bool success) {
      print("Success = ${success}");
      Fluttertoast.showToast(
          msg: "Download Complete",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
    })
        : await downloadAndroid(url);

    pr.hide();
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

                  if (type == "Share") {
                    shareFile(
                        "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");
                  } else {
                    _saveNetworkImage(
                        "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Gallery'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumAllImages(),
              ),
            ).then((value) {
              debugPrint(value);
              getLocalData();
            });*/
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Platform.isIOS
              ? Container()
              : GestureDetector(
                  onTap: () {
                    /*_saveNetworkImage(
                        "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");*/
                    if (SelectedPin != "" &&
                        (PinSelection == "false" ||
                            PinSelection == "" ||
                            PinSelection.toString() == "null")) {
                      _openDialog("Download");
                    } else {
                      _saveNetworkImage(
                          "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        downloading == true
                            ? Container(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                                height: 25,
                                width: 25,
                              )
                            : Icon(
                                Icons.file_download,
                                size: 20,
                                color: Colors.white,
                              ),
                        Text(
                          "Download",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
          GestureDetector(
            onTap: () {
              /*shareFile(
                  "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");*/
              //Share
              if (SelectedPin != "" &&
                  (PinSelection == "false" ||
                      PinSelection == "" ||
                      PinSelection.toString() == "null")) {
                _openDialog("Download");
              } else {
                shareFile(
                    "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 8.0, right: 14),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.share,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    "Share",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          setState(() {
            //_value++;
          });
          if (details.velocity.pixelsPerSecond.dx > -1000.0) {
            print("Drag Left - SubValue");
            /*if(widget.albumData.length-1==widget.albumIndex){
            }else{
              setState(() {
                widget.albumIndex=widget.albumIndex+1;
              });
            }*/
            if (widget.albumIndex != 0) {
              setState(() {
                widget.albumIndex = widget.albumIndex - 1;
              });
            }
            print("Current Index = ${widget.albumData.length}");
            print("Total Size = ${widget.albumIndex}");
          } else {
            print("Drag Right - AddValue");
            if (widget.albumData.length - 1 == widget.albumIndex) {
            } else {
              setState(() {
                widget.albumIndex = widget.albumIndex + 1;
              });
            }
            print("Current Index = ${widget.albumData.length}");
            print("Total Size = ${widget.albumIndex}");
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: Stack(
            /*crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,*/
            children: <Widget>[
              Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )),
              Center(
                child: PhotoView(
                  imageProvider: NetworkImage(
                    //"${cnst.ImgUrl}" + widget.albumData[widget.albumIndex]["Photo"],
                    "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}",
//                    fit: BoxFit.contain,
//                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height - 100,
                  ),
                  loadingChild: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
