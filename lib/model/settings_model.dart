import 'package:flutter/material.dart';

class Settings{

  Color? _appBarColor ;
  String? _appMode;
  String? _country;

  Settings({ String? appMode, String? country}){
    _appBarColor=Colors.red;
    _appMode=appMode;
    _country=country;
  }

  Color? get getAppBarColor =>_appBarColor;
  String? get getAppMode=>_appMode;
  String? get getCountry=>_country;

  set setAppBarColor(Color? color){
    _appBarColor=color;
  }

  set setAppMode(String? appMode){
    _appMode=appMode;
  }

  set setCountry(String? country){
    _country=country;
  }

}