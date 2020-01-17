import 'package:flutter/material.dart';
import 'package:insta_album_new/Screen/SelectedAlbum.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;


class AlbumComponent extends StatefulWidget {
  var AlbumData;

  AlbumComponent(this.AlbumData);

  @override
  _AlbumComponentState createState() => _AlbumComponentState();
}

class _AlbumComponentState extends State<AlbumComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectedAlbum(
                albumId: widget.AlbumData["Id"].toString(),
                albumName: widget.AlbumData["Name"],
                totalImg: widget.AlbumData["NoOfPhoto"].toString()),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(7),
        elevation: 5,
        child: Stack(
          children: <Widget>[
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(6.0),
                child: widget.AlbumData["Photo"] != null
                    ? FadeInImage.assetNetwork(
                        placeholder: 'images/om.png',
                        image:
                            "${cnst.ImgUrl}${widget.AlbumData["Photo"]}",
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 5, top: 5),
                    child: Text(
                      '${widget.AlbumData["Name"]}',
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
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    child: Text(
                      '${widget.AlbumData["SelectedPhotoCount"]}/${widget.AlbumData["NoOfPhoto"]}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
