import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  static const String _nameKey = 'user_name';
  static const String _subjectsKey = 'user_subjects';
  static const String _classKey = 'user_class';
  static const String _boardKey = 'user_board';

  // Save user name
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  // Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  // Save selected subjects
  static Future<void> saveUserSubjects(List<String> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_subjectsKey, subjects);
  }

  // Get selected subjects
  static Future<List<String>> getUserSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_subjectsKey) ?? [];
  }

  // Save user class
  static Future<void> saveUserClass(int userClass) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_classKey, userClass);
  }

  // Get user class
  static Future<int?> getUserClass() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_classKey);
  }

  // Save user board
  static Future<void> saveUserBoard(String board) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_boardKey, board);
  }

  // Get user board
  static Future<String?> getUserBoard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_boardKey);
  }
}
