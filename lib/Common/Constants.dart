import 'package:flutter/material.dart';

const String API_URL = "http://instaalbum.itfuturz.com/api/AppAPI/";
const String ImgUrl = "http://insta"
    "album.itfuturz.com/";
//const String API_URL = "${cnst.ImgUrl}api/AppAPI/";
//const String API_URL = "http://thestudioom.itfuturz.com/AppAPI/";
const Inr_Rupee = "₹";
const Studio_Id= "7";
const Color appcolor = Color.fromRGBO(0, 171, 199, 1);
const Color secondaryColor = Color.fromRGBO(85, 96, 128, 1);

const String whatsAppLink = "https://wa.me/#mobile?text=#msg"; //mobile no with country code

Map<int, Color> appprimarycolors = {
  50: Color.fromRGBO(160,228,224, .1),
  100: Color.fromRGBO(160,228,224, .2),
  200: Color.fromRGBO(160,228,224, .3),
  300: Color.fromRGBO(160,228,224, .4),
  400: Color.fromRGBO(160,228,224, .5),
  500: Color.fromRGBO(160,228,224, .6),
  600: Color.fromRGBO(160,228,224, .7),
  700: Color.fromRGBO(160,228,224, .8),
  800: Color.fromRGBO(160,228,224, .9),
  900: Color.fromRGBO(160,228,224, 1)
};

MaterialColor appPrimaryMaterialColor = MaterialColor(0xFFA0E4E0, appprimarycolors);

class MESSAGES {
  static const String INTERNET_ERROR = "No Internet Connection";
  static const String INTERNET_ERROR_RETRY =
      "No Internet Connection.\nPlease Retry";
}

class Session{

  static const String CustomerId = "CustomerId";
  static const String ParentId = "ParentId";
  static const String Mobile = "Mobile";
  static const String Name = "Name";
  static const String CompanyName = "CompanyName";
  static const String Email = "Email";
  static const String IsVerified = "IsVerified";
  static const String StudioId = "StudioId";
  static const String Type = "Type";
  static const String PinSelection = "PinSelection";
  static const String SelectedPin = "SelectedPin";

  static const String Photo = "Photo";


  static const String DOB = "DOB";
  static const String Gender = "Gender";
  static const String Address = "Address";
  static const String Pincode = "Pincode";
  static const String HospitalName = "HospitalName";
  static const String HospitalAddress = "HospitalAddress";
  static const String DoctorName = "DoctorName";
  static const String DoctorRegistrationNo = "DoctorRegistrationNo";
  static const String HandicappedNature_DisabilityPercentage = "HandicappedNature_DisabilityPercentage";

  static const String Landline = "Landline";
  static const String RegistrationDate = "RegistrationDate";
  static const String Place = "Place";
  static const String SignImage = "SignImage";
  static const String RailwayCertificate = "RailwayCertificate";
  static const String DisabilityCertificate = "DisabilityCertificate";
  static const String PhotoIdProof = "PhotoIdProof";
  static const String AddressProof = "AddressProof";
  static const String CurrentStatus = "CurrentStatus";
  static const String CardNo = "CardNo";
  static const String IssueDate = "IssueDate";
  static const String ValidTill = "ValidTill";

  //temp store
  //static const String ChapterId = "ChapterId";
  static const String CommitieId = "CommitieId";
  static const String SlideShowSpeed = "SlideShowSpeed";
  static const String PlayMusic = "PlayMusic";
  static const String MusicURL = "MusicURL";
}
