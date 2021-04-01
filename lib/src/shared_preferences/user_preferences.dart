import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get gender {
    return _prefs.getInt('gender') ?? 1;
  }

  set gender(int value) {
    _prefs.setInt('gender', value);
  }

  get secundaryColor {
    return _prefs.getBool('secundaryColor') ?? false;
  }

  set secundaryColor(bool value) {
    _prefs.setBool('secundaryColor', value);
  }

  get token {
    return _prefs.getString('token') ?? null;
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get lastPage {
    return _prefs.getString('lastPage') ?? 'home';
  }

  set lastPage(String value) {
    _prefs.setString('lastPage', value);
  }
}
