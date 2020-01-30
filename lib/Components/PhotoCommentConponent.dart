import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class PhotoCommentConponent extends StatefulWidget {
  var data;
  String CustomerId;
  Function onChange;

  PhotoCommentConponent(this.data, this.CustomerId, this.onChange);

  @override
  _PhotoCommentConponentState createState() => _PhotoCommentConponentState();
}

class _PhotoCommentConponentState extends State<PhotoCommentConponent> {
  void _showConfirmDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("PICTIK"),
          content: new Text("Are You Sure You Want To Delete Comment ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onChange("delete", widget.data["Id"].toString());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  /*ClipOval(
                    child: widget.data["Image"] != null &&
                            widget.data["Image"] != ""
                        ? FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: cnst.ImgUrl + widget.data["Image"],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'images/icon_user.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                  ),*/
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${widget.data["Name"]}',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          '${widget.data["Comment"]}',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  )),
                  widget.data["CustomerId"].toString() == widget.CustomerId
                      ? GestureDetector(
                          onTap: () {
                            _showConfirmDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.blueAccent,
                              size: 22,
                            ),
                          ),
                        )
                      : Container()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
