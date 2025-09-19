import 'package:radio_player_test/data/services/storage_service.dart';

class AuthService {
  // Проверка авторизации при запуске
  static Future<bool> checkAuthStatus() async {
    return await StorageService.isAuthenticated();
  }

  // Получение данных текущего пользователя
  static Future<Map<String, String?>> getCurrentUser() async {
    return await StorageService.getUserData();
  }

  // Выход из системы
  static Future<void> signOut() async {
    await StorageService.clearAuthData();
  }

  // Получение токена
  static Future<String?> getToken() async {
    return await StorageService.getAuthToken();
  }
}
