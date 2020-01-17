import 'dart:convert';


class SaveDataClass {
  String Message;
  bool IsSuccess;
  String Data;

  SaveDataClass({this.Message, this.IsSuccess, this.Data});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data'] as String);
  }
}

class timeClassData {
  String Message;
  bool IsSuccess;
  List<timeClass> Data;

  timeClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory timeClassData.fromJson(Map<String, dynamic> json) {
    return timeClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<timeClass>((json) => timeClass.fromJson(json))
            .toList());
  }
}

class timeClass {
  String id;
  String time;
  String IsBooked;

  timeClass({this.id, this.time, this.IsBooked});

  factory timeClass.fromJson(Map<String, dynamic> json) {
    return timeClass(
        id: json['Id'].toString() as String,
        time: json['Title'].toString() as String,
      IsBooked: json['IsBooked'].toString() as String,
    );
  }
}
