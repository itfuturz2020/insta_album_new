import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class PortfolioImageView extends StatefulWidget {
  List albumData;
  int albumIndex;

  PortfolioImageView({this.albumData, this.albumIndex});

  @override
  _PortfolioImageViewState createState() => _PortfolioImageViewState();
}

class _PortfolioImageViewState extends State<PortfolioImageView> {
  bool downloading = false;

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
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
                    _downloadFile(widget.albumData[widget.albumIndex]["Image"]);
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
              shareFile(
                  "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Image"]}");
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
                    "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Image"]}",
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
