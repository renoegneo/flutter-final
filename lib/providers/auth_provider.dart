import 'package:flutter/foundation.dart';

import '../models/event.dart';
import '../services/cloud_api_service.dart';
import '../services/cloud_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final CloudApiService _api = CloudApiService();
  final CloudStorageService _storage = CloudStorageService();

  String _baseUrl = 'http://127.0.0.1:8000';
  String? _token;
  String? _username;
  bool _isLoading = false;
  String? _errorMessage;

  String get baseUrl => _baseUrl;
  String? get username => _username;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get errorMessage => _errorMessage;

  Future<void> loadSession() async {
    final session = await _storage.loadSession();
    _baseUrl = session.baseUrl;
    _token = session.token;
    _username = session.username;
    notifyListeners();
  }

  Future<bool> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanUrl = _sanitizeBaseUrl(baseUrl);

    try {
      final token = await _api.login(
        baseUrl: cleanUrl,
        username: username,
        password: password,
      );
      final serverUsername = await _api.fetchUsername(
        baseUrl: cleanUrl,
        token: token,
      );

      _baseUrl = cleanUrl;
      _token = token;
      _username = serverUsername;
      await _storage.saveSession(
        baseUrl: cleanUrl,
        token: token,
        username: serverUsername,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanUrl = _sanitizeBaseUrl(baseUrl);

    try {
      final token = await _api.register(
        baseUrl: cleanUrl,
        username: username,
        password: password,
      );
      final serverUsername = await _api.fetchUsername(
        baseUrl: cleanUrl,
        token: token,
      );

      _baseUrl = cleanUrl;
      _token = token;
      _username = serverUsername;
      await _storage.saveSession(
        baseUrl: cleanUrl,
        token: token,
        username: serverUsername,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _username = null;
    _errorMessage = null;
    await _storage.clearSession();
    notifyListeners();
  }

  Future<void> uploadEvents(List<Event> events) async {
    final token = _token;
    if (token == null) {
      throw StateError('Not authorized');
    }

    await _api.replaceSchedule(
      baseUrl: _baseUrl,
      token: token,
      events: events,
    );
  }

  Future<List<Event>> downloadEvents() async {
    final token = _token;
    if (token == null) {
      throw StateError('Not authorized');
    }

    return _api.fetchSchedule(baseUrl: _baseUrl, token: token);
  }

  Future<void> rememberBaseUrl(String baseUrl) async {
    final cleanUrl = _sanitizeBaseUrl(baseUrl);
    _baseUrl = cleanUrl;
    await _storage.saveBaseUrl(cleanUrl);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _sanitizeBaseUrl(String baseUrl) {
    return baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
  }
}
