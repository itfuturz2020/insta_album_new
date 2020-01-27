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
import 'package:shared_preferences/shared_preferences.dart';

class CustomerGallery extends StatefulWidget {
  @override
  _CustomerGalleryState createState() => _CustomerGalleryState();
}

class _CustomerGalleryState extends State<CustomerGallery> {
  DateTime currentBackPressTime;
  bool dialVisible = true;

  String SelectedPin="";

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
  }

  getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    SelectedPin = preferences.getString(Session.SelectedPin);

    setState(() {
      SelectedPin = SelectedPin;
    });
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
        onWillPop: () {
          onWillPop();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                            return GalleryComponent(snapshot.data[index],SelectedPin);
                          },
                        )
                      : NoDataComponent()
                  : LoadinComponent();
            },
          ),
        ),
      ),
    );
  }
}
