import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event.dart';

class CloudApiException implements Exception {
  final String message;

  CloudApiException(this.message);

  @override
  String toString() => message;
}

class CloudApiService {
  Future<String> register({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('${_normalizeBaseUrl(baseUrl)}/api/v1/auth/register');

    final response = await http.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = _decodeJson(response);
    _throwIfFailed(response.statusCode, data);

    return (data['access_token'] as String?) ??
        (throw CloudApiException('Server did not return token'));
  }

  Future<String> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('${_normalizeBaseUrl(baseUrl)}/api/v1/auth/login');

    final response = await http.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = _decodeJson(response);
    _throwIfFailed(response.statusCode, data);

    return (data['access_token'] as String?) ??
        (throw CloudApiException('Server did not return token'));
  }

  Future<String> fetchUsername({
    required String baseUrl,
    required String token,
  }) async {
    final uri = Uri.parse('${_normalizeBaseUrl(baseUrl)}/api/v1/auth/me');

    final response = await http.get(
      uri,
      headers: _authHeaders(token),
    );

    final data = _decodeJson(response);
    _throwIfFailed(response.statusCode, data);

    return (data['username'] as String?) ??
        (throw CloudApiException('Server did not return username'));
  }

  Future<void> replaceSchedule({
    required String baseUrl,
    required String token,
    required List<Event> events,
  }) async {
    final uri =
        Uri.parse('${_normalizeBaseUrl(baseUrl)}/api/v1/schedule/events');

    final response = await http.put(
      uri,
      headers: {
        ..._authHeaders(token),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'events': events.map((e) => e.toMap()).toList(),
      }),
    );

    final data = _decodeJson(response);
    _throwIfFailed(response.statusCode, data);
  }

  Future<List<Event>> fetchSchedule({
    required String baseUrl,
    required String token,
  }) async {
    final uri =
        Uri.parse('${_normalizeBaseUrl(baseUrl)}/api/v1/schedule/events');

    final response = await http.get(
      uri,
      headers: _authHeaders(token),
    );

    final data = _decodeJson(response);
    _throwIfFailed(response.statusCode, data);

    if (data is! List) {
      throw CloudApiException('Invalid schedule response format');
    }

    return data
        .map((raw) => Event.fromMap(raw as Map<String, dynamic>))
        .toList();
  }

  String _normalizeBaseUrl(String baseUrl) {
    return baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
  }

  Map<String, String> _authHeaders(String token) {
    return {'Authorization': 'Bearer $token'};
  }

  dynamic _decodeJson(http.Response response) {
    if (response.bodyBytes.isEmpty) return <String, dynamic>{};
    final text = utf8.decode(response.bodyBytes);
    if (text.trim().isEmpty) return <String, dynamic>{};

    try {
      return jsonDecode(text);
    } catch (_) {
      return <String, dynamic>{'detail': text};
    }
  }

  void _throwIfFailed(int statusCode, dynamic data) {
    if (statusCode >= 200 && statusCode < 300) return;

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        throw CloudApiException(detail);
      }
    }

    throw CloudApiException('Request failed with status code $statusCode');
  }
}
