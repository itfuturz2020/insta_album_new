import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/AlbumComponent.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';

class Home extends StatefulWidget {

  String galleryId;

  Home(this.galleryId);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List>(
          future: Services.GetCustomerAlbumList(widget.galleryId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.data!=null && snapshot.data.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AlbumComponent(snapshot.data[index]);
                        },
                      )
                    : NoDataComponent()
                : LoadinComponent();
          },
        ),
      ),
    );
  }
}
