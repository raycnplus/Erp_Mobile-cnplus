import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:erp_mobile_cnplus/features/auth/data/models/login_response.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveDatabase(String database);
  Future<String?> getDatabase();
  Future<void> saveUserData(UserData user);
  Future<Map<String, String?>> getUserData();
  Future<void> clearAll();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSourceImpl(this._storage);

  static const String _tokenKey = 'token';
  static const String _databaseKey = 'database';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _namaLengkapKey = 'nama_lengkap';
  static const String _idUserKey = 'id_user';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> saveDatabase(String database) async {
    await _storage.write(key: _databaseKey, value: database);
  }

  @override
  Future<String?> getDatabase() async {
    return await _storage.read(key: _databaseKey);
  }

  @override
  Future<void> saveUserData(UserData user) async {
    if (user.idUser != null) {
      await _storage.write(key: _idUserKey, value: user.idUser.toString());
    }
    if (user.username != null) {
      await _storage.write(key: _usernameKey, value: user.username!);
    }
    if (user.email != null) {
      await _storage.write(key: _emailKey, value: user.email!);
    }
    if (user.namaLengkap != null) {
      await _storage.write(key: _namaLengkapKey, value: user.namaLengkap!);
    }
  }

  @override
  Future<Map<String, String?>> getUserData() async {
    return {
      'id_user': await _storage.read(key: _idUserKey),
      'username': await _storage.read(key: _usernameKey),
      'email': await _storage.read(key: _emailKey),
      'nama_lengkap': await _storage.read(key: _namaLengkapKey),
    };
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}