import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class AllAlbumComponent extends StatefulWidget {
  var albumData;
  int index;
  Function onChange;

  AllAlbumComponent(this.albumData, this.index, this.onChange);

  @override
  _AllAlbumComponentState createState() => _AllAlbumComponentState();
}

class _AllAlbumComponentState extends State<AllAlbumComponent> {
  bool downloading = false;

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
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
                        //height: MediaQuery.of(context).size.height / 1.7,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Image.asset(
                        'images/icon_events.jpg',
                        fit: BoxFit.fill,
                        //height: MediaQuery.of(context).size.height / 1.7,
                        width: MediaQuery.of(context).size.width,
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
                          if (widget.albumData["IsSelected"].toString() ==
                              "true") {
                            setState(() {
                              widget.albumData["IsSelected"] = "false";
                            });
                            widget.onChange(
                                "Remove", widget.albumData["Id"].toString());
                          } else {
                            setState(() {
                              widget.albumData["IsSelected"] = "true";
                            });
                            widget.onChange(
                                "Add", widget.albumData["Id"].toString());
                          }
                        },
                        child:
                            widget.albumData["IsSelected"].toString() == "true"
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
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                  ),
                      ),
                      Platform.isIOS
                          ? Container(
                        height: 30,
                        width: 30,
                      )
                          : GestureDetector(
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
                          shareFile(
                              "${cnst.ImgUrl}${widget.albumData["Photo"].toString()}");
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
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
