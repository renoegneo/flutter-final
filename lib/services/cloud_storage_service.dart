import 'package:shared_preferences/shared_preferences.dart';

class CloudSession {
  final String baseUrl;
  final String? token;
  final String? username;

  const CloudSession({
    required this.baseUrl,
    required this.token,
    required this.username,
  });
}

class CloudStorageService {
  static const _baseUrlKey = 'cloud.base_url';
  static const _tokenKey = 'cloud.token';
  static const _usernameKey = 'cloud.username';

  Future<CloudSession> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return CloudSession(
      baseUrl: prefs.getString(_baseUrlKey) ?? 'http://127.0.0.1:8000',
      token: prefs.getString(_tokenKey),
      username: prefs.getString(_usernameKey),
    );
  }

  Future<void> saveSession({
    required String baseUrl,
    required String token,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, baseUrl);
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
  }

  Future<void> saveBaseUrl(String baseUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, baseUrl);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }
}
