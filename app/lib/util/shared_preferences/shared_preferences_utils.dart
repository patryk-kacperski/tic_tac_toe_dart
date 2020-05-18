import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferencesUtil instance;
  final SharedPreferences sharedPreferences;

  SharedPreferencesUtil._(this.sharedPreferences);

  static const String _displayNameKey = "display_name_key";
  static const String _colorKey = "color_key";

  /// Call this once at the start of the app lifecycle to initialize shared preferences
  static Future<void> initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final instance = SharedPreferencesUtil._(sharedPreferences);
    SharedPreferencesUtil.instance = instance;
  }

  bool get isNameSet =>
      sharedPreferences.containsKey(_displayNameKey) &&
      sharedPreferences.getString(_displayNameKey) != null;

  bool get isColorSet =>
      sharedPreferences.containsKey(_colorKey) &&
      sharedPreferences.getInt(_colorKey) != null;

  bool get isDataSet => isNameSet && isColorSet;

  String get displayName =>
      isNameSet ? sharedPreferences.getString(_displayNameKey) : null;
  set displayName(String value) =>
      sharedPreferences.setString(_displayNameKey, value);

  int get color =>
      isColorSet ? sharedPreferences.getInt(_colorKey) : null;
  set color(int value) => sharedPreferences.setInt(_colorKey, value);
}
