import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresAtKey = 'expires_at';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_expiresAtKey, expiresAt.toIso8601String());
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<DateTime?> getExpiresAt() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAtStr = prefs.getString(_expiresAtKey);
    if (expiresAtStr != null) {
      return DateTime.parse(expiresAtStr);
    }
    return null;
  }

  Future<bool> hasValidToken() async {
    final accessToken = await getAccessToken();
    final expiresAt = await getExpiresAt();

    if (accessToken == null || expiresAt == null) {
      return false;
    }

    return DateTime.now().isBefore(expiresAt);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_expiresAtKey);
  }
}
