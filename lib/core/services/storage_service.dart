import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late StorageService? _instance;
  static late SharedPreferences? _preferences;

  static Future<StorageService?> getInstance() async {
    _instance ??= StorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }
}
