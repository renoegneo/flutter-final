class AppConfig {
  const AppConfig._();

  // You can override it at build/run time:
  // flutter run -d edge --dart-define=BACKEND_URL=http://192.168.43.120:8000
  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );
}
