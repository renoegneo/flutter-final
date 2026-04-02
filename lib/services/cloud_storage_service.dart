import 'package:shared_preferences/shared_preferences.dart';

class CloudSession {
  final String? token;
  final String? username;

  const CloudSession({
    required this.token,
    required this.username,
  });
}

class CloudStorageService {
  static const _tokenKey = 'cloud.token';
  static const _usernameKey = 'cloud.username';

  Future<CloudSession> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return CloudSession(
      token: prefs.getString(_tokenKey),
      username: prefs.getString(_usernameKey),
    );
  }

  Future<void> saveSession({
    required String token,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }
}
