import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_audio_player/cloud_audio_player.dart';
import 'package:cloud_audio_player/cloud_player_state.dart';
import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class SelectedPhotoShow extends StatefulWidget {
  List allPhotos;

  SelectedPhotoShow({this.allPhotos});

  @override
  _SelectedPhotoShowState createState() => _SelectedPhotoShowState();
}

class _SelectedPhotoShowState extends State<SelectedPhotoShow> {
  List imageList = new List();
  int _value;
  @override
  CloudAudioPlayer _player;
  String _statusText = "";

  void initState() {
    _player = CloudAudioPlayer();
    _player.addListeners(
      statusListener: _onStatusChanged,
    );
    getLocal();
    for (int i = 0; i < widget.allPhotos.length; i++) {
      imageList.add(cnst.ImgUrl + widget.allPhotos[i]["Photo"]);
    }
  }

  getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double time = double.parse(prefs.getString(cnst.Session.SlideShowSpeed));
    setState(() {
      _value = (time * 1000).round();
    });
    _playMusic(prefs.getString(cnst.Session.MusicURL));

  }

  _playMusic(String URL) {
    _player.play(URL);
  }

  void _onPause() {
    _player.pause();
  }

  _onStatusChanged(CloudPlayerState status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _statusText = status.toString();
    });
    if (_statusText == "CloudPlayerState.COMPLETED") {
      _playMusic(prefs.getString(cnst.Session.MusicURL));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Timer: ${_value}");
    return WillPopScope(
      onWillPop: () {
        _onPause();
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    _onPause();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: Colors.white),
                )
              ],
            ),
            body: Center(
              child: Container(
                //height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  autoplayDuration: Duration(milliseconds: _value),
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
      ),
    );
  }
}
