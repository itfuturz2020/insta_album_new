import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:path/path.dart' as p;

class PortfolioImagesComponent extends StatefulWidget {
  var albumData;
  int index;
  Function onChange;

  PortfolioImagesComponent(this.albumData, this.index, this.onChange);

  @override
  _PortfolioImagesComponentState createState() =>
      _PortfolioImagesComponentState();
}

class _PortfolioImagesComponentState extends State<PortfolioImagesComponent> {
  bool downloading = false;
  File newFile, compressedFile;

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
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
    ImgUrl = ImgUrl.replaceAll(" ", "%20");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient().getUrl(Uri.parse("${ImgUrl}"));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setImage();
  }

  setImage() async {
    await cmpImage();
  }

  cmpImage() async {
    newFile = await convertFile("flutter.png");
    /*compressedFile = await FlutterNativeImage.compressImage(newFile.path,
        quality: 10, percentage: 10);*/
    compressedFile = await FlutterNativeImage.compressImage(newFile.path,
        quality: 1, targetWidth: 100, percentage: 1);

    setState(() {
      compressedFile = compressedFile;
      print("Cmp File = $compressedFile");
    });
    setState(() {});
    print("path    " + newFile.path);
  }

  Future<File> convertFile(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
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
                  child: widget.albumData["Image"] != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/icon_events.jpg',
                          image: "${cnst.ImgUrl}${widget.albumData["ImageThumb"]}",
                          fit: BoxFit.cover,
                          //height: MediaQuery.of(context).size.height / 1.7,
                          width: MediaQuery.of(context).size.width,
                        )
                      /*Image(
                      image: NetworkToFileImage(
                          url:
                          "${cnst.ImgUrl}${widget.albumData["Image"]}",
                          debug: true,
                          file: compressedFile))*/
                      : Image.asset(
                          'images/icon_events.jpg',
                          fit: BoxFit.fill,
                          //height: MediaQuery.of(context).size.height / 1.7,
                          width: MediaQuery.of(context).size.width,
                        ),
                ),
                /*GestureDetector(
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
                  child: Align(
                    alignment: Alignment.bottomRight,
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
                ),*/
                /*GestureDetector(
                  onTap: () {
                    _downloadFile(widget.albumData["Image"]);
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 27,
                      width: 27,
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
                ),*/
                GestureDetector(
                  onTap: () {
                    shareFile(
                        "${cnst.ImgUrl}${widget.albumData["Image"].toString()}");
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Icon(
                        Icons.share,
                        size: 17,
                      ),
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
