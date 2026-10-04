class AppConfig {
  static const useMocks = bool.fromEnvironment('USE_MOCKS', defaultValue: true);
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const token = String.fromEnvironment(
    'LOCAL_API_TOKEN',
    defaultValue: 'local-user-demo',
  );
}
