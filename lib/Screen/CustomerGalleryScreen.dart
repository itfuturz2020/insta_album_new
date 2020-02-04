import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/AlbumComponent.dart';
import 'package:insta_album_new/Components/CustomerGalleryComponent.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Screen/AdvertisemnetDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerGallery extends StatefulWidget {
  @override
  _CustomerGalleryState createState() => _CustomerGalleryState();
}

class _CustomerGalleryState extends State<CustomerGallery> {
  DateTime currentBackPressTime;
  bool dialVisible = true;
  int _current = 0;

  String SelectedPin = "";
  List _advertisementData = new List();
  List _albumData = new List();
  bool isLoading = true;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
    callMethod();
  }

  callMethod() async {
    await getAdvertisementData();
    await getAlbumData();
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

  getAdvertisementData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetAllAdvertisement();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _advertisementData = data;
              isLoading = false;
            });
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

  getAlbumData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetCustomerGalleryList();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _albumData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _albumData.clear();
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

  getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    SelectedPin = preferences.getString(Session.SelectedPin);
    setState(() {
      SelectedPin = SelectedPin;
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 8,
        marginBottom: 8,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(
          size: 22.0,
        ),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: dialVisible,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        //tooltip: 'Speed Dial',
        //heroTag: 'speed-dial-hero-tag',
        backgroundColor: cnst.appPrimaryMaterialColor,
        foregroundColor: Colors.black,
        //child: Icon(Icons.add),
        elevation: 4.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.access_time),
              backgroundColor: Colors.deepPurple,
              label: 'Book Appointment',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushNamed(context, '/BookAppointment');
              }),
          SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: 'Share Album',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/MyCustomer');
              }),
          SpeedDialChild(
              child: Icon(Icons.brush),
              backgroundColor: Colors.blue,
              label: 'View Portfolio',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushNamed(context, '/PortfolioScreen');
              }),
          SpeedDialChild(
            child: Icon(Icons.link),
            backgroundColor: Colors.green,
            label: 'Social Link',
            labelStyle: TextStyle(fontSize: 17.0),
            onTap: () {
              Navigator.pushNamed(context, '/SocialLink');
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading?LoadinComponent() :Column(
            children: <Widget>[
              _advertisementData.length > 0
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: CarouselSlider(
                            height: 170,
                            viewportFraction: 0.9,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1500),
                            reverse: false,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlay: true,
                            onPageChanged: (index) {
                              setState(() {
                                _current = index;
                              });
                            },
                            items: _advertisementData.map((i) {
                              return Builder(builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdvertisemnetDetail(
                                          i,
                                        ),
                                      ),
                                    );
                                  },
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/loading.gif',
                                    image: cnst.ImgUrl + i["Image"],
                                    fit: BoxFit.fill,
                                  ),
                                );
                              });
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: map<Widget>(
                            _advertisementData,
                            (index, url) {
                              return Container(
                                width: 7.0,
                                height: 7.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: _current == index
                                        ? Colors.white
                                        : Colors.grey),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
              /*Expanded(
                child: FutureBuilder<List>(
                  future: Services.GetCustomerGalleryList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.connectionState == ConnectionState.done
                        ? snapshot.data != null && snapshot.data.length > 0
                            ? ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: snapshot.data.length,
                                //shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return GalleryComponent(
                                      snapshot.data[index], SelectedPin);
                                },
                              )
                            : NoDataComponent()
                        : LoadinComponent();
                  },
                ),
              ),*/
              _albumData.length > 0
                  ? Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: _albumData.length,
                        //shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GalleryComponent(_albumData[index], SelectedPin);
                        },
                      ),
                  )
                  : Expanded(child: NoDataComponent()),
            ],
          ),
        ),
      ),
    );
  }
}
