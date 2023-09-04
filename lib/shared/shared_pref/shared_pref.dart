import 'package:shared_preferences/shared_preferences.dart';

class PrefsClass{

//  initialization
  static late SharedPreferences preferences;

  static  init() async{
    preferences = await SharedPreferences.getInstance();
  }

//  functions

static Future<void> setString(
      {
    required String key,
    required String value
}
    )async{
   await preferences.setString(key, value);
}

  static String? getString({
    required String key
}){
    return preferences.getString(key);
}

static Future<void> deleteString({
    required String key
}) async {
  await preferences.remove(key);
}
}