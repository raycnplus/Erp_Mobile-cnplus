class AppConfig {
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'prod');

  static bool get isLocal => _env == 'local';

  static String get baseUrl {
    switch (_env) {
      case 'local':
        return 'http://192.168.1.29/api'; // IP LOCAL
      case 'server_test':
        return 'http://192.168.1.100/cnersia/api';
      case 'prod':
      default:
        return 'https://erp.cnersia.com/api';
    }
  }

  static String? get hostHeader => isLocal ? 'cnersia.test' : null;

  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshEndpoint = '/auth/refresh-token';

  static const String tokenKey = 'token';
  static const String databaseKey = 'database';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  static const String namaLengkapKey = 'nama_lengkap';
}