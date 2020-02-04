import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:neeko/neeko.dart';
import 'package:video_player/video_player.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;

class AdvertisemnetDetail extends StatefulWidget {
  var data;

  AdvertisemnetDetail(this.data);

  @override
  _AdvertisemnetDetailState createState() => _AdvertisemnetDetailState();
}

class _AdvertisemnetDetailState extends State<AdvertisemnetDetail> {
  bool isLoading = true;
  List _advertisementData = new List();

  GoogleMapController mapController;
  LatLng _lastMapPosition = _center;

  static const LatLng _center = const LatLng(21.1408283, 72.8030316);
  Set<Marker> markers = Set();

  var AdverDetails;
  List PhotoList = new List();

  /*static const String beeUri =
      'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4';

  final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
      DataSource.network(
          'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
          displayName: "displayName"));*/

  @override
  void initState() {
    super.initState();
    /*markers.addAll([
      Marker(
          markerId: MarkerId('value'),
          position: LatLng(21.1408283, 72.8030316)),
      */ /*Marker(
          markerId: MarkerId('value2'),
          position: LatLng(21.141474, 72.840138)),*/ /*
    ]);*/
    callMethod();
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  callMethod() async {
    await getAdvertisementDetails();
  }

  showMsg(String msg, {String title = 'PICTIK'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getAdvertisementDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res =
            Services.GetAdvertisementDetail(widget.data["Id"].toString());
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _advertisementData = data;
              //isLoading = false;
            });
            await setData(data);
          } else {
            setState(() {
              isLoading = false;
              _advertisementData.clear();
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  setData(List data) async {
    setState(() {
      AdverDetails = data[0]["Advertisement"];
      PhotoList = data[0]["PhotoList"];
      var file = data[0]["Advertisement"]["Location"].split(',');

      print(data[0]["Advertisement"]["Location"]);
      markers.addAll([
        Marker(
            markerId: MarkerId('value'),
            position: LatLng(double.parse(file[0].toString()),
                double.parse(file[1].toString()))),
        /*Marker(
          markerId: MarkerId('value2'),
          position: LatLng(21.141474, 72.840138)),*/
      ]);

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advertise Detail"),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading == false
              ? _advertisementData.length > 0
                  ? SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 3,
                            child: Column(
                              children: <Widget>[
                                /*NeekoPlayerWidget(
                                  onSkipPrevious: () {
                                    print("skip");
                                    videoControllerWrapper.prepareDataSource(
                                        DataSource.network(
                                            "http://vfx.mtime.cn/Video/2019/03/12/mp4/190312083533415853.mp4",
                                            displayName:
                                                "This house is not for sale"));
                                  },
                                  videoControllerWrapper:
                                      videoControllerWrapper,
                                  actions: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          print("share");
                                        })
                                  ],
                                ),*/
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.new_releases,
                                        size: 15,
                                        color: Colors.grey[600],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 4)),
                                      Expanded(
                                        child: Text(
                                          "${AdverDetails["Title"]}",
                                          //"Title",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 3, bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Icon(
                                          Icons.message,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 4)),
                                      Expanded(
                                        child: Text(
                                          "${AdverDetails["Description"]}",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PhotoList.length > 0
                                    ? CarouselSlider.builder(
                                        height: 170,
                                        viewportFraction: 1.0,
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 1500),
                                        reverse: false,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        autoPlay: true,
                                        itemCount: PhotoList.length,
                                        itemBuilder: (BuildContext context,
                                            int itemIndex) {
                                          return Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/loading.gif',
                                                image: cnst.ImgUrl +
                                                    PhotoList[itemIndex]
                                                        ["Photo"],
                                                fit: BoxFit.fill,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 170,
                                              ));
                                        },
                                      )
                                    : Container(),
                                /*Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Stack(children: [
                          Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: _controller.value.initialized
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  )
                                : Container(),
                          ),
                          Positioned(
                            bottom: 2,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                                icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 27)),
                          ),
                        ]),
                      ),*/
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    child: Text("Contact Information",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700])),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Name :",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "Website :",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            //"${widget.data["MemberName"]}",
                                            "Member Name",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              //launch("http://itfuturz.com/");
                                            },
                                            child: Text(
                                              "http://itfuturz.com/",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          //_openWhatsapp(widget.data["ContactNo"]);
                                        },
                                        child: Container(
                                          color: Colors.green[400],
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.29,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 3),
                                          child: Image.asset(
                                            "images/whatsapp.png",
                                            width: 43,
                                            height: 43,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //launch('mailto:sagartech9teen@gmail.com?subject=&body=');
                                          //launch('mailto:${widget.data["Email"].toString()}?subject=&body=');
                                        },
                                        child: Container(
                                          color: cnst.appPrimaryMaterialColor,
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.29,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 7),
                                          child: Image.asset(
                                            "images/mail.png",
                                            width: 23,
                                            height: 12,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //launch("tel:${widget.data["ContactNo"]}");
                                        },
                                        child: Container(
                                          color: Colors.green[400],
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.29,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 7),
                                          child: Image.asset(
                                            "images/call.png",
                                            width: 23,
                                            height: 23,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: cnst.appPrimaryMaterialColor,
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.29,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        child: Image.asset(
                                          "images/navigation.png",
                                          width: 23,
                                          height: 23,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: GoogleMap(
                                    markers: markers,
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: 11.0,
                                    ),
                                    onCameraMove: _onCameraMove,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : NoDataComponent()
              : LoadinComponent()),
    );
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

/*_handleTap(LatLng point) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'I am a marker',
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
  }*/
}
