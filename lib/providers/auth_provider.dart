import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../models/event.dart';
import '../services/cloud_api_service.dart';
import '../services/cloud_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final CloudApiService _api = CloudApiService();
  final CloudStorageService _storage = CloudStorageService();

  final String _baseUrl = AppConfig.backendUrl;
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
    _token = session.token;
    _username = session.username;
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _api.login(
        baseUrl: _baseUrl,
        username: username,
        password: password,
      );
      final serverUsername = await _api.fetchUsername(
        baseUrl: _baseUrl,
        token: token,
      );

      _token = token;
      _username = serverUsername;
      await _storage.saveSession(
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
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _api.register(
        baseUrl: _baseUrl,
        username: username,
        password: password,
      );
      final serverUsername = await _api.fetchUsername(
        baseUrl: _baseUrl,
        token: token,
      );

      _token = token;
      _username = serverUsername;
      await _storage.saveSession(
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
