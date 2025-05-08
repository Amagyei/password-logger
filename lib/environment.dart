class Environment {
  static const String _currentEnv = 'development'; // Change to 'production' for production

  static const Map<String, String> _config = {
    'development': 'http://10.0.2.2:8002/',
    'production': 'https://erpxpand.com/',
  };

  static String get apiBaseUrl => _config[_currentEnv]!;
}