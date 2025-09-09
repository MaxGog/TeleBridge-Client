import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveBotToken(String token) async {
    await _storage.write(
      key: 'bot_token',
      value: token,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  Future<String?> getBotToken() async {
    return await _storage.read(
      key: 'bot_token',
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  IOSOptions _getIOSOptions() => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
}