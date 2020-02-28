import 'dart:io';

import 'package:cloud_audio_player/cloud_audio_player.dart';
import 'package:cloud_audio_player/cloud_player_state.dart';
import 'package:flutter/material.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectSound extends StatefulWidget {
  @override
  _SelectSoundState createState() => _SelectSoundState();
}

class _SelectSoundState extends State<SelectSound> {
  bool isLoading = true;
  List soundData = [];
  String selectedMusic = "";
  CloudAudioPlayer _player;
  String _statusText = "";

  @override
  void initState() {
    _player = CloudAudioPlayer();
    _player.addListeners(
      statusListener: _onStatusChanged,
    );
    _getLocal();
    _getMusic();
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

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(cnst.Session.MusicURLId) != null ||
        prefs.getString(cnst.Session.MusicURLId) != "") {
      setState(() {
        selectedMusic = prefs.getString(cnst.Session.MusicURLId);
      });
    }
    print("Selected Music ${selectedMusic}");
    print("Selected Music URL ${prefs.getString(cnst.Session.MusicURL)}");
  }

  _getMusic() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetSoundData();
        isLoading = true;
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              soundData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Myask Call $e");
          showMsg("Try Again.");
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
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

  setMusicURl(String Id, String Url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedMusic = Id;
      prefs.setString(cnst.Session.MusicURLId, Id);
      prefs.setString(cnst.Session.MusicURL, cnst.ImgUrl + Url);
      print("Selected Music::: ${prefs.getString(cnst.Session.MusicURLId)}");
      print("Selected Music URL::: ${prefs.getString(cnst.Session.MusicURL)}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        _onPause();
        Navigator.pop(context);
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Background Music",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
              onPressed: () {
                _onPause();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black)),
          /*actions: <Widget>[
            PlayerWidget(url: "http://instaalbum.itfuturz.com/Sound/BGTrack2.mp3"),
          ],*/
        ),
        body: isLoading
            ? LoadinComponent()
            : soundData.length > 0
                ? ListView.builder(
                    itemCount: soundData.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              //setMusicURl(soundData[index]["Id"].toString(),
                              //  soundData[index]["Id"].toString());
                              setState(() {
                                selectedMusic = soundData[index]["Id"].toString();
                                prefs.setString(cnst.Session.MusicURLId,
                                    soundData[index]["Id"].toString());
                                prefs.setString(
                                    cnst.Session.MusicURL,
                                    cnst.ImgUrl +
                                        soundData[index]["Sound"].toString());
                                print(
                                    "Selected Music::: ${prefs.getString(cnst.Session.MusicURLId)}");
                                print(
                                    "Selected Music URL::: ${prefs.getString(cnst.Session.MusicURL)}");
                              });
                              _playMusic(prefs.getString(cnst.Session.MusicURL));
                            },
                            child: ListTile(
                              leading: Radio(
                                activeColor: cnst.appPrimaryMaterialColor,
                                value: '${soundData[index]["Id"]}',
                                groupValue: selectedMusic,
                                //activeColor: Colors.green,
                                onChanged: (val) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    /*setMusicURl(soundData[index]["Id"].toString(),
                                        soundData[index]["Id"].toString());*/
                                    selectedMusic = val;
                                    selectedMusic =
                                        soundData[index]["Id"].toString();
                                    prefs.setString(cnst.Session.MusicURLId,
                                        soundData[index]["Id"].toString());
                                    prefs.setString(
                                        cnst.Session.MusicURL,
                                        cnst.ImgUrl +
                                            soundData[index]["Sound"].toString());
                                    print(
                                        "Selected Music::: ${prefs.getString(cnst.Session.MusicURLId)}");
                                    print(
                                        "Selected Music URL::: ${prefs.getString(cnst.Session.MusicURL)}");
                                  });
                                  _playMusic(
                                      prefs.getString(cnst.Session.MusicURL));
                                },
                              ),
                              title: Text(soundData[index]["Sound"]),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          )
                        ],
                      );
                    },
                  )
                : NoDataComponent(),
      ),
    );
  }
}
