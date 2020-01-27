import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class SelectedPhotoShow extends StatefulWidget {
  List allPhotos;

  SelectedPhotoShow({this.allPhotos});

  @override
  _SelectedPhotoShowState createState() => _SelectedPhotoShowState();
}

class _SelectedPhotoShowState extends State<SelectedPhotoShow> {
  List imageList = new List();

  @override
  void initState() {
    for (int i = 0; i < widget.allPhotos.length; i++) {
      imageList.add(cnst.ImgUrl + widget.allPhotos[i]["Photo"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.clear, color: Colors.white),
              )
            ],
          ),
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              child: Carousel(
                defaultImage: "assets/loading.gif",
                images: imageList.map((url) {
                  return Image(
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Image.asset("assets/loading.gif");
                      },
                      image: NetworkImage(url));
                }).toList(),
                showIndicator: false,
                borderRadius: true,
                noRadiusForIndicator: true,
                overlayShadow: false,
              ),
            ),
          )),
    );
  }
}
