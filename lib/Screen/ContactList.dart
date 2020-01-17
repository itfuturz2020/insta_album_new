import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Common/Constants.dart' as cnst;
import 'package:insta_album_new/Components/NoDataComponent.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  List<CustomContact> _searchContact = new List<CustomContact>();

  //List<CustomContact> _allContacts = List<CustomContact>();
  bool _isLoading = false;
  List _selectedContact = [];
  String memberId="";
  String parentId="";
  bool isSearching =  false;

  TextEditingController txtSearch = new TextEditingController();

  @override
  void initState() {
    refreshContacts();
  }

  refreshContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(Session.CustomerId).toString();
    String ParentId = prefs.getString(Session.ParentId).toString();
    print("ParentId Init = ${ParentId}");
    setState(() {
      memberId=MemberId;
      parentId=ParentId;
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    setState(() {
      _uiCustomContacts =
          _contacts.map((contact) => CustomContact(contact: contact)).toList();
      _searchContact =
          _contacts.map((contact) => CustomContact(contact: contact)).toList();
      _isLoading = false;
    });
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      leading: (c.contact.avatar != null && c.contact.avatar.length > 0)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          : CircleAvatar(
              child: Text(
                c.contact.displayName.toUpperCase().substring(0, 1) ?? "",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            _onChange(value, c, list);
          }),
    );
  }

  _onChange(value, CustomContact c, List<Item> list) {
    if (list.length >= 1 &&
        list[0]?.value != null &&
        c.contact.displayName != "") {
      String mobile = list[0].value.toString();
      String name = c.contact.displayName.toString();
      mobile = mobile.replaceAll(" ", "");
      mobile = mobile.replaceAll("-", "");
      mobile = mobile.replaceAll("+91", "");
      mobile = mobile.replaceAll("091", "");
      mobile = mobile.replaceAll("+091", "");
      mobile = mobile.replaceAll(RegExp("^0"), "");
      mobile = mobile.replaceAll(RegExp("^0261"), "");
      print("mobile" + mobile);
      if (value) {
        if (mobile.length == 10) {
          setState(() {
            c.isChecked = value;
          });
          print("parentId = ${parentId}");
          print("memberId = ${memberId}");
          _selectedContact.add({
            "Id": 0,
            "ParentId":
                parentId.toString() == "null" || parentId == "0" ? memberId : parentId,
            "Name": "${name}",
            "Mobile": "${mobile}",
            "Type": 'Member',
            "InviteStatus":'Pending'
          });
        } else
          Fluttertoast.showToast(
              msg: "Mobile Number Is Not Valid",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          c.isChecked = value;
        });
        for (int i = 0; i < _selectedContact.length; i++) {
          if (_selectedContact[i]["Mobile"].toString() == mobile)
            _selectedContact.removeAt(i);
        }
      }
      print(_selectedContact);
    } else {
      Fluttertoast.showToast(
          msg: "Contact Is Not Valid",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  _addCustomer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        print(_selectedContact);
        Services.AddCustomer(_selectedContact).then((data) async {
          setState(() {
            _isLoading = false;
          });
          if (data.Data == "1") {
            Fluttertoast.showToast(
                msg: "Customer Added Successfully",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushReplacementNamed(context, "/AddCustomer");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            _isLoading = false;
          });
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
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void searchOperation(String searchText) {
    if (searchText != "") {
      setState(() {
        _searchContact.clear();
        isSearching = true;
      });
      String mobile = "";
      for (int i = 0; i < _uiCustomContacts.length; i++) {
        String name = _uiCustomContacts[i].contact.displayName;
        var _phonesList = _uiCustomContacts[i].contact.phones.toList();
        if (_phonesList.length > 0) mobile = _phonesList[0].value;
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            mobile.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            _searchContact.add(_uiCustomContacts[i]);
          });
        }
      }
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/AddCustomer");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Choose Contacts",style: TextStyle(fontSize: 15),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/AddCustomer");
              }),
          actions: <Widget>[
            _isLoading
                ? Container()
                : _selectedContact.length > 0
                    ? GestureDetector(
                        onTap: () {
                          _addCustomer();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                                width: 90,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, right: 3, top: 2, bottom: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Add",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.send,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ))),
                      )
                    : Container(),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:8.0,right: 8.0,left: 8.0),
              child: TextFormField(
                onChanged: searchOperation,
                controller: txtSearch,
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                    counter: Text(""),
                    border: new OutlineInputBorder(
                        borderSide:
                        new BorderSide(color: Colors.black),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8))),
                    suffixIcon: Icon(
                      Icons.search,
                      color: cnst.appPrimaryMaterialColor,
                    ),
                    hintText: "Search Contact"),
                maxLength: 10,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              child:_isLoading
                  ? LoadinComponent()
                  : _uiCustomContacts.length > 0
                  ? isSearching
                  ? ListView.builder(
                itemCount: _searchContact?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact = _searchContact[index];
                  var _phonesList =
                  _contact.contact.phones.toList();
                  return _buildListTile(_contact, _phonesList);
                },
              )
                  : ListView.builder(
                itemCount: _uiCustomContacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact =
                  _uiCustomContacts[index];
                  var _phonesList =
                  _contact.contact.phones.toList();
                  return _buildListTile(_contact, _phonesList);
                },
              )
                  : NoDataComponent(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({
    this.contact,
    this.isChecked = false,
  });
}
