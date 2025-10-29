import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../services/api_base.dart'; 
import '../models/profile_model.dart'; 

class AuthService {
  final _storage = const FlutterSecureStorage();

  /// Mengambil data profil pengguna
  Future<Profile> getProfile() async {
    final token = await _storage.read(key: 'token');
    // Pastikan endpoint Anda benar (contoh: /profile)
    final url = Uri.parse("${ApiBase.baseUrl}/profile"); 

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); 
      return Profile.fromJson(data);
    } else {
      throw Exception("Gagal memuat profil: ${response.statusCode}");
    }
  }

  /// fungsi logout pengguna
  Future<void> logout(BuildContext context) async {
    final token = await _storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/auth/logout"); 

    try {
      await http.post(
        url,
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 5)); 
      
    } catch (e) {
      debugPrint("API Logout error (diabaikan): $e");

    } finally {
      // [PENTING] Blok finally akan SELALU dijalankan.
      
      // 1. Hapus semua data simpanan (token, dll)
      await _storage.deleteAll();

      // 2. Redirect ke halaman Login dan hapus semua halaman sebelumnya
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Ganti jika nama route login Anda berbeda
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}