import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPreferences;

  static bool isInstance()  {
    return  _sharedPreferences != null;
  }

  static Future<void> setInstance() async {
    if (_sharedPreferences != null) return;

    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static const unit = 'unit';
  static Future<bool>? setUnit(String value) => _sharedPreferences?.setString(unit, value);
  static String getUnit() => _sharedPreferences?.getString(unit) ?? '円';
  //static Future<void> removeUnit() => _sharedPreferences.remove(unit);

  static const loginCount = 'loginCount';
  static Future<bool>? setLoginCount(int value) => _sharedPreferences?.setInt(loginCount, value);
  static int getLoginCount() => _sharedPreferences?.getInt(loginCount) ?? 0;
  //
  // static Future<bool> setTapIndex(String value) => _sharedPreferences.setString(tapIndex, value);
  // static String getTapIndex() => _sharedPreferences.getString(tapIndex) ?? 'both';
  //
  static const adPositionTop = 'adPositionTop';
  static Future<bool>? setAdPositionTop(bool value) => _sharedPreferences?.setBool(adPositionTop, value);
  static bool getAdPositionTop() => _sharedPreferences?.getBool(adPositionTop) ?? true;
  // 【共通】
  static const isFaceID = 'isFaceID';
  static Future<bool>? setIsFaceID(bool value) => _sharedPreferences?.setBool(isFaceID, value);
  static bool getIsFaceID() => _sharedPreferences?.getBool(isFaceID) ?? false;

  static const isPassword = 'isPassword';
  static Future<bool>? setIsPassword(bool value) => _sharedPreferences?.setBool(isPassword, value);
  static bool getIsPassword() => _sharedPreferences?.getBool(isPassword) ?? false;

  static const password = 'password';
  static Future<bool>? setPassword(String value) => _sharedPreferences?.setString(password, value);
  static String getPassword() => _sharedPreferences?.getString(password) ?? '0000';

  //【共通】サブスク非表示時間
  static Future<bool>? setSubscString(String value) => _sharedPreferences?.setString('subscTimeLimit', value);
  static String getSubscString() => _sharedPreferences?.getString('subscTimeLimit') ?? '';

  //【共通】リワード時間
  static Future<bool>? setRewardTime(String value) => _sharedPreferences?.setString('rewardTime', value);
  static String getRewardTime() => _sharedPreferences?.getString('rewardTime') ?? '2021-01-01 00:00:00';

  static const customColor = 'customColor';
  static Future<bool>? setCustomColor(String value) => _sharedPreferences?.setString(customColor, value);
  static String getCustomColor() => _sharedPreferences?.getString(customColor) ?? '0xFF8FCFFA';

  static const textSize = 'textSize';
  static Future<bool>? setTextSize(double value) => _sharedPreferences?.setDouble(textSize, value);
  static double getTextSize() => _sharedPreferences?.getDouble(textSize) ?? 16.0;

  static const textColor = 'textColor';
  static Future<bool>? setTextColor(String value) => _sharedPreferences?.setString(textColor, value);
  static String getTextColor() => _sharedPreferences?.getString(textColor) ?? '0xDD000000';

  //【共通】リワード時間
  static const isZeroHidden = 'isZeroHidden';
  static Future<bool>? setIsZeroHidden(bool value) => _sharedPreferences?.setBool(isZeroHidden, value);
  static bool getIsZeroHidden() => _sharedPreferences?.getBool(isZeroHidden) ?? false;
}
