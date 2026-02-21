class ApiConfig {
  static const String baseUrl = 'http://192.168.0.193:8000';

  static const String apiKey = 'your-secret-api-key-change-in-env';

  static const Duration requestTimeout = Duration(seconds: 30);

  static const int maxRetries = 3;

  static const int initialRetryDelay = 1000;
}
