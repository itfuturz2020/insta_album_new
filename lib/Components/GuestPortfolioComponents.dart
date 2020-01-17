import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Screen/GuestportfolioImages.dart';

class GuestPortfolioComponents extends StatefulWidget {
  var GalleryData;

  GuestPortfolioComponents(this.GalleryData);
  @override
  _GuestPortfolioComponentsState createState() => _GuestPortfolioComponentsState();
}

class _GuestPortfolioComponentsState extends State<GuestPortfolioComponents> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GuestportfolioImages(
                    widget.GalleryData["Id"].toString(),
                    widget.GalleryData["Title"].toString())));
      },
      child: Card(
        color: Colors.green,
        margin: EdgeInsets.all(0),
        elevation: 5,
        child: Stack(
          children: <Widget>[
            Container(
              //height: 190,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(6.0),
                child: widget.GalleryData["Image"] != null
                    ? FadeInImage.assetNetwork(
                  placeholder: 'images/icon_events.jpg',
                  image: "${cnst.ImgUrl}${widget.GalleryData["Image"]}",
                  fit: BoxFit.cover,
                )
                /*Image(
                        image: NetworkToFileImage(
                            url: "${cnst.ImgUrl}${widget.GalleryData["Image"]}",
                            debug: true,
                            file: compressedFile))*/
                    : Container(
                  color: Colors.grey[100],
                ),
              ),
            ),
            Container(
              //height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.7),
                      Color.fromRGBO(0, 0, 0, 0.7),
                      Color.fromRGBO(0, 0, 0, 0.7),
                      Color.fromRGBO(0, 0, 0, 0.7)
                    ],
                  ),
                  //borderRadius: new BorderRadius.all(Radius.circular(6)),
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 5, top: 5),
                child: Text(
                  '${widget.GalleryData["Title"]}',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            /*Padding(
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
            ),*/
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
