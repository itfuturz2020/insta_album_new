import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Pages/Home.dart';
import 'package:insta_album_new/Screen/SelectedAlbum.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class GalleryComponent extends StatefulWidget {
  var GalleryData;

  GalleryComponent(this.GalleryData);

  @override
  _GalleryComponentState createState() => _GalleryComponentState();
}

class _GalleryComponentState extends State<GalleryComponent> {

  setData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.SelectedPin, "${widget.GalleryData["SelectionPin"].toString()}");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Home(widget.GalleryData["Id"].toString(),widget.GalleryData["Title"].toString(),widget.GalleryData["IsSelectionDone"].toString())));

  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        setData();
      },
      child: Card(
        color: Colors.green,
        margin: EdgeInsets.all(7),
        elevation: 5,
        child: Stack(
          children: <Widget>[
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(6.0),
                child: widget.GalleryData["GalleryCover"] != null
                    ? FadeInImage.assetNetwork(
                        placeholder: 'images/om.png',
                        image:
                            "${cnst.ImgUrl}${widget.GalleryData["GalleryCover"]}",
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[100],
                      ),
              ),
            ),
            Container(
              height: 190,
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
                borderRadius: new BorderRadius.all(Radius.circular(6)),
              ),
            ),
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 5, top: 5),
                    child: Text(
                      '${widget.GalleryData["Title"]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
//            Container(
//              height: 190,
//              width: MediaQuery.of(context).size.width,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.end,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.only(left: 20, bottom: 5),
//                    child: Text(
//                      '${widget.GalleryData["SelectedPhotoCount"]}/${widget.GalleryData["NoOfPhoto"]}',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 15,
//                          fontWeight: FontWeight.w600),
//                    ),
//                  ),
//                ],
//              ),
//            )
          ],
        ),
      ),
    );
  }
}
