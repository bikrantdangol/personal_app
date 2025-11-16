import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _keyUsername = 'user_name';
  static const String _keyAddress = 'usr_addr';
  static const String _profileImagepath = 'usr_img';

  static const String _userEmail = "user_email";
    static const String _userPassword = "user_Password";


  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? "Add name here!";
  }


    static Future<void> setUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmail, userEmail);
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmail) ?? "";
  }

      static Future<void> setUserPasswordl(String userPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPassword, userPassword);
  }

  static Future<String> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPassword) ?? "";
  }

  static Future<void> setAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, address);
  }

  static Future<String> getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAddress) ?? "Add Address here!";
  }

  static Future<void> setProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImagepath, path);
  }

  static Future<String> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImagepath) ?? "";
  }
}
