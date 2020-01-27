import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_album_new/Common/ClassList.dart';
import 'package:insta_album_new/Common/Constants.dart';
import 'package:insta_album_new/Screen/AddCustomer.dart';
import 'package:insta_album_new/Screen/BookAppointment.dart';

Dio dio = new Dio();

class Services {
  //login funtion
  static Future<List> MemberLogin(String mobileNo) async {
    String url = API_URL + 'CustomerLogin?mobileNo=$mobileNo';
    print("MemberLogin URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("MemberLogin Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("MemberLogin Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> sendOtpCode(String mobileno, String code) async {
    String url = API_URL + 'SendVerificationCode?mobileNo=$mobileno&code=$code';
    print("sendOtpCode URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("sendOtpCode Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("sendOtpCode Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  //Get Album Details
  static Future<List> getAlbumData(String galleryId) async {
    String url = API_URL + 'GetDashboardAlbumList?customerId=$galleryId';
    print("getAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("getAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = null;
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("getAlbumData Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetAboutUs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String StudioId = preferences.getString(Session.StudioId);
    String url = API_URL + 'GetStudioAboutList?studioId=$StudioId';
    print("GetAboutUs URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAboutUs Response: " + response.data.toString());
        var data = response.data;
        if (data["IsSuccess"] == true && data["Data"].length > 0) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetAboutUs Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetAlbumData(String AlbumId) async {
    String url = API_URL + 'GetCustomerAlbumByAlbumId?albumId=$AlbumId';
    print("GetAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetAlbumData Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetAlbumAllData(String AlbumId) async {
    String url = API_URL + 'GetAlbumPhotoList?AlbumId=$AlbumId';
    print("GetAlbumAllData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAlbumAllData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetAlbumAllData Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetCategoryAlbumAllData(String AlbumId) async {
    String url = API_URL + 'GetPortfolioList?CategoryId=$AlbumId';
    print("GetPortfolioList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPortfolioList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetPortfolioList Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetSelectedAlbumData(String AlbumId) async {
    String url = API_URL + 'GetSelectedAlbumPhotoList?AlbumId=$AlbumId';
    print("GetSelectedAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetSelectedAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSelectedAlbumData Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetPendingAlbumData(String AlbumId) async {
    String url = API_URL + 'GetPendingAlbumPhotoList?AlbumId=$AlbumId';
    print("GetPendingAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPendingAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetPendingAlbumData Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> UploadSelectedImage(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateAlbumSelection';
    print("UploadSelectedImage url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("UploadSelectedImage Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("UploadSelectedImage");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("UploadSelectedImage Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //Send Fcm Token
  static Future<List> SendTokanToServer(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String CustomerId = prefs.getString(Session.CustomerId);

    String url = API_URL +
        'UpdateCustomerFCMToken?customerId=$CustomerId&fcmToken=$fcmToken';
    print("SendTokanToServer URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("SendTokanToServer  URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true) {
          print(memberDataClass["Data"]);
          //list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SendTokanToServer URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Notification From Server
  static Future<List> GetNotificationFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String CustomerId = prefs.getString(Session.CustomerId);

    String url = API_URL + 'GetCustomerNotificationList?customerId=$CustomerId';
    print("GetNotificationFromServer URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetNotificationFromServer: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetNotificationFromServer Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> CodeVerification(String MemberId) async {
    String url = API_URL + 'CustomerOTPVerification?customerId=$MemberId';
    print("CodeVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("CodeVerification Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CodeVerification Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetCustomerGalleryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String CustomerId = prefs.getString(Session.CustomerId);

    String url = API_URL + 'GetCustomerGalleryList?customerId=$CustomerId';
    print("GetCustomerGalleryList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCustomerGalleryList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetCustomerGalleryList Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetportfolioGalleryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String StudioId = prefs.getString(Session.StudioId);

    String url = API_URL + 'GetCategoryList?studioId=$StudioId';
    print("GetportfolioGalleryList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCategoryList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetportfolioGalleryList Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetCustomerAlbumList(String galleryId) async {
    String url = API_URL + 'GetCustomerAlbumList?galleryId=$galleryId';
    print("GetCustomerAlbumList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCustomerAlbumList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetCustomerAlbumList Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> AddCustomer(body) async {
    print(body.toString());
    String url = API_URL + 'SaveCustomerList';
    print("AddCustomer url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("AddCustomer Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddCustomer ${e.toString()}");
      throw Exception(e.toString());
    }
  }


  static Future<SaveDataClass> GuestSignUp(body) async {
    print(body.toString());
    String url = API_URL + 'SaveCustomerList';
    print("AddCustomer url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("AddCustomer Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddCustomer ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetSocialLinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String StudioId = prefs.getString(Session.StudioId);

    String url = API_URL + 'GetStudioSocialLinkList?studioId=$StudioId';
    print("GetSocialLinks URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetSocialLinks Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSocialLinks Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<timeClass>> getTimeSlots(date) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String StudioId = preferences.getString(Session.StudioId);
    String url = API_URL + 'GetAppointmentSlotList?studioId=$StudioId&date=$date';
    print("getTimeSlots Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<timeClass> timeClassList = [];
        print("getTimeSlots Response" + response.data.toString());

        final jsonResponse = response.data;
        timeClassData data = new timeClassData.fromJson(jsonResponse);

        timeClassList = data.Data;

        return timeClassList;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check getTimeSlots Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> BookAppointment(body) async {
    print(body.toString());
    String url = API_URL + 'SaveAppointment';
    print("BookAppointment url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("BookAppointment Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error BookAppointment ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> MyCustomerList(String CustomerId) async {
    String url = API_URL + 'GetCustomerChildList?customerId=$CustomerId';
    print("GetChildCustomerList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetChildCustomerList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetChildCustomerList Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> DeleteChileCustomer(String ChildGuestId) async {
    String url = API_URL + 'DeleteCustomerWithChild?id=$ChildGuestId';
    print("Delete ChildGuest URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false,Data: "");
        print("Delete ChildGuest Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Delete ChildGuest Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateInviteStatus(String ChildGuestId) async {
    String url = API_URL + 'UpdateCustomerStatus?customerId=$ChildGuestId';
    print("UpdateInvite Status URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false,Data: "");
        print("UpdateInvite Status Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("UpdateInvite Status Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> ShareAppMessage(String StudioId) async {
    String url = API_URL + 'GetStudioInviteMessage?studioId=$StudioId';
    print("Studio App Share URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false,Data: "");
        print("Studio App Share Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Studio App Share Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateGallrySelection(String galleryId,String status) async {
    String url = API_URL + 'UpdateGallerySelectionStatus?galleryId=$galleryId&status=$status';
    print("Studio App Share URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false,Data: "");
        print("Studio App Share Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Studio App Share Erorr : " + e.toString());
      throw Exception(e);
    }
  }
  static Future<List> GetSoundData() async {
    String url = API_URL + 'GetBackgroundMusic';
    print("GetBackgroundMusic URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetBackgroundMusic Response: " + response.data.toString());
        var data = response.data;
        if (data["IsSuccess"] == true && data["Data"].length > 0) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetBackgroundMusic Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }
}
