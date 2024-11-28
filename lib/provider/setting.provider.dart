import 'package:flutter/cupertino.dart';
import '../model/settings_model.dart';

class SettingsProvider extends ChangeNotifier{
  late final Settings _settings;

  SettingsProvider({String? appMode})
      : _settings = Settings( appMode: appMode,country: "en");

  get appBarColor => _settings.getAppBarColor;

  get appMode => _settings.getAppMode;

  get country => _settings.getCountry;

  void setAppBarColor(Color? color) {
    _settings.setAppBarColor = color;
    notifyListeners();
  }

  void setAppMode(String? mode) {
    _settings.setAppMode = mode;
    notifyListeners();
  }

  void setCountry(String? country) {
    _settings.setCountry = country;
    notifyListeners();
  }

}
