import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get memory => _prefs.getString('memory') ?? '';
  static set memory(String value) => _prefs.setString('memory', value);

  static String get user => _prefs.getString('user') ?? 'User';
  static set user(String value) => _prefs.setString('user', value);

  static String get ai => _prefs.getString('ai') ?? 'AI';
  static set ai(String value) => _prefs.setString('ai', value);

  static double get pValue => _prefs.getDouble('pValue') ?? 0.88;
  static set pValue(double value) => _prefs.setDouble('pValue', value);

  static int get kValue => _prefs.getInt('kValue') ?? 5;
  static set kValue(int value) => _prefs.setInt('kValue', value);

  static double get tValue => _prefs.getDouble('tValue') ?? 0.78;
  static set tValue(double value) => _prefs.setDouble('tValue', value);
}
