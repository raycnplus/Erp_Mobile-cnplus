import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ❌ SharedPreferences tidak lagi digunakan
// import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_base.dart';
import '../models/login_request.dart';

class AuthService {
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static Future<Map<String, dynamic>> login(LoginRequest loginReq) async {
    final url = Uri.parse('${ApiBase.baseUrl}/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(loginReq.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      final user = data['user'];

      await _secureStorage.write(key: 'token', value: token);

      if (user != null) {
        if (user['username'] != null) {
          await _secureStorage.write(key: 'username', value: user['username']);
        }
        if (user['email'] != null) {
          await _secureStorage.write(key: 'email', value: user['email']);
        }
        if (user['nama_lengkap'] != null) {
          await _secureStorage.write(key: 'nama_lengkap', value: user['nama_lengkap']);
        }
      }

      return {'success': true, 'user': user, 'token': token};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Terjadi kesalahan'};
    }
  }
}