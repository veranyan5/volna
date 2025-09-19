import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _authProviderKey = 'auth_provider';

  // Сохранение токена авторизации
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Получение токена авторизации
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Сохранение данных пользователя
  static Future<void> saveUserData({
    required String email,
    required String name,
    required String authProvider,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_authProviderKey, authProvider);
  }

  // Получение данных пользователя
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_userEmailKey),
      'name': prefs.getString(_userNameKey),
      'authProvider': prefs.getString(_authProviderKey),
    };
  }

  // Проверка авторизации
  static Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Очистка всех данных авторизации
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_authProviderKey);
  }

  // Сохранение полных данных авторизации
  static Future<void> saveAuthData({
    required String token,
    required String email,
    required String name,
    required String authProvider,
  }) async {
    await saveAuthToken(token);
    await saveUserData(
      email: email,
      name: name,
      authProvider: authProvider,
    );
  }
}
