import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLink extends StatefulWidget {
  @override
  _SocialLinkState createState() => _SocialLinkState();
}

class _SocialLinkState extends State<SocialLink> {
  bool isLoading = false;
  List _socialLinkData = [];

  @override
  void initState() {
    getSocialLinks();
  }

  getSocialLinks() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetSocialLinks();
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _socialLinkData = data;
            });
          } else {}
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : $e");
          showMsg("$e");
        });
      } else {
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
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Social Links"),
      ),
      body: isLoading
          ? LoadinComponent()
          : Container(
              margin: EdgeInsets.only(left: 7, bottom: 7, right: 7, top: 12),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "images/om.png",
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  _socialLinkData.length > 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _socialLinkData.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  _launchURL(
                                      "${_socialLinkData[index]["Link"]}");
                                },
                                child: Card(
                                  margin: EdgeInsets.all(5),
                                  child: Container(
                                    padding: EdgeInsets.all(7),
                                    child: Row(
                                      children: <Widget>[
                                        _socialLinkData[index]["Image"] != null
                                            ? FadeInImage.assetNetwork(
                                                placeholder:
                                                    'images/insta_placeholder.png',
                                                image:
                                                    "${cnst.ImgUrl}${_socialLinkData[index]["Image"]}",
                                                fit: BoxFit.cover,
                                                height: 35,
                                                width: 35,
                                              )
                                            : Image.asset(
                                                'images/insta_placeholder.png',
                                                fit: BoxFit.fill,
                                                height: 35,
                                                width: 35,
                                              ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 15)),
                                        Text(
                                          "${_socialLinkData[index]["Title"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : NoDataComponent(),
                ],
              ),
            ),
    );
  }
}
