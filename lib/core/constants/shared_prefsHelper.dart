// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// class SharedPrefsHelper {
//   static const String _userDataKey = 'user_data';
//   static const String _isLoggedInKey = 'is_logged_in';
//
//   // Save user data after login
//   static Future<void> saveUserData(Map<String, dynamic> userData) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userDataKey, json.encode(userData));
//     await prefs.setBool(_isLoggedInKey, true);
//   }
//
//   // Get user data
//   static Future<Map<String, dynamic>?> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userDataString = prefs.getString(_userDataKey);
//     if (userDataString != null) {
//       return json.decode(userDataString);
//     }
//     return null;
//   }
//
//   // Get specific user field
//   static Future<String?> getUserField(String field) async {
//     final userData = await getUserData();
//     return userData?['user']?[field]?.toString();
//   }
//
//   // Get username
//   static Future<String> getUsername() async {
//     final name = await getUserField('name');
//     return name ?? 'User';
//   }
//
//   // Get user ID
//   static Future<String?> getUserId() async {
//     return await getUserField('Userid');
//   }
//
//   // Get user image URL
//   static Future<String?> getUserImageUrl() async {
//     return await getUserField('imageUrl');
//   }
//
//   // Get user category
//   static Future<String?> getUserCategory() async {
//     return await getUserField('Category');
//   }
//
//   // Check if user is logged in
//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isLoggedInKey) ?? false;
//   }
//
//   // Clear user data (logout)
//   static Future<void> clearUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_userDataKey);
//     await prefs.setBool(_isLoggedInKey, false);
//   }
//
//   // Save individual preference
//   static Future<void> saveString(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key, value);
//   }
//
//   // Get individual preference
//   static Future<String?> getString(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }
// }


import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save user data after login
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, json.encode(userData));
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  // Get specific user field
  static Future<String?> getUserField(String field) async {
    final userData = await getUserData();
    return userData?['user']?[field]?.toString();
  }

  // Get username
  static Future<String> getUsername() async {
    final name = await getUserField('name');
    return name ?? 'User';
  }

  // Get user ID
  static Future<String?> getUserId() async {
    return await getUserField('Userid');
  }

  // Get user image URL
  static Future<String?> getUserImageUrl() async {
    return await getUserField('imageUrl');
  }

  // Get user category
  static Future<String?> getUserCategory() async {
    return await getUserField('Category');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear user data (logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Save individual preference
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Get individual preference
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}