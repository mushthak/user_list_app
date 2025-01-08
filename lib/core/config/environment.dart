class Environment {
  static const development = 'development';
  static const production = 'production';
  static const testing = 'testing';

  static String currentEnvironment = development;

  static bool get isDevelopment => currentEnvironment == development;
  static bool get isProduction => currentEnvironment == production;
  static bool get isTesting => currentEnvironment == testing;
}

class AppConfig {
  final String databaseName;
  final int databaseVersion;
  final bool enableLogging;

  const AppConfig({
    required this.databaseName,
    required this.databaseVersion,
    required this.enableLogging,
  });

  factory AppConfig.development() {
    return const AppConfig(
      databaseName: 'user_database_dev.db',
      databaseVersion: 1,
      enableLogging: true,
    );
  }

  factory AppConfig.production() {
    return const AppConfig(
      databaseName: 'user_database.db',
      databaseVersion: 1,
      enableLogging: false,
    );
  }

  factory AppConfig.testing() {
    return const AppConfig(
      databaseName: 'user_database_test.db',
      databaseVersion: 1,
      enableLogging: true,
    );
  }

  static AppConfig getConfig() {
    switch (Environment.currentEnvironment) {
      case Environment.development:
        return AppConfig.development();
      case Environment.production:
        return AppConfig.production();
      case Environment.testing:
        return AppConfig.testing();
      default:
        return AppConfig.development();
    }
  }
}
