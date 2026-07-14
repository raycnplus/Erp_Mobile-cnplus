// lib/features/auth/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/config/app_config.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';

class AuthService {
  final DioClient _dioClient;
  final _storage = const FlutterSecureStorage();
  
  AuthService(this._dioClient);
  
  // Login
  Future<Map<String, dynamic>> login(LoginRequest loginReq) async {
    try {
      final response = await _dioClient.dio.post(
        AppConfig.loginEndpoint,
        data: loginReq.toJson(),
      );
      
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        
        // Simpan token dan user data
        await _storage.write(key: 'token', value: loginResponse.token);
        await _storage.write(key: 'database', value: loginReq.database);
        
        if (loginResponse.user != null) {
          final user = loginResponse.user!;
          if (user.username != null) {
            await _storage.write(key: 'username', value: user.username!);
          }
          if (user.email != null) {
            await _storage.write(key: 'email', value: user.email!);
          }
          if (user.namaLengkap != null) {
            await _storage.write(key: 'nama_lengkap', value: user.namaLengkap!);
          }
        }
        
        return {
          'success': true,
          'user': loginResponse.user,
          'token': loginResponse.token,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Terjadi kesalahan',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
  
  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _dioClient.dio.post(AppConfig.logoutEndpoint);
      
      // Clear storage
      await _storage.deleteAll();
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Berhasil logout',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Gagal logout',
        };
      }
    } on DioException catch (e) {
      // Tetap clear storage meski error
      await _storage.deleteAll();
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      await _storage.deleteAll();
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
  
  // Refresh Token
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final oldToken = await _storage.read(key: 'token');
      final database = await _storage.read(key: 'database') ?? 'mysql';
      
      if (oldToken == null) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan',
        };
      }
      
      final response = await _dioClient.dio.post(
        AppConfig.refreshEndpoint,
        data: {
          'token': oldToken,
          'database': database,
        },
      );
      
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        
        // Update token
        await _storage.write(key: 'token', value: loginResponse.token);
        
        // Update user data jika ada
        if (loginResponse.user != null) {
          final user = loginResponse.user!;
          if (user.username != null) {
            await _storage.write(key: 'username', value: user.username!);
          }
          if (user.email != null) {
            await _storage.write(key: 'email', value: user.email!);
          }
          if (user.namaLengkap != null) {
            await _storage.write(key: 'nama_lengkap', value: user.namaLengkap!);
          }
        }
        
        return {
          'success': true,
          'user': loginResponse.user,
          'token': loginResponse.token,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Gagal refresh token',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }
  
  // Get current token
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
  
  // Handle Dio Errors
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Silakan coba lagi.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? e.response?.data['error'];
        if (statusCode == 401) {
          return message ?? 'Username atau password salah';
        } else if (statusCode == 500) {
          return 'Terjadi kesalahan pada server';
        }
        return message ?? 'Terjadi kesalahan: $statusCode';
      case DioExceptionType.cancel:
        return 'Request dibatalkan';
      case DioExceptionType.unknown:
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      default:
        return 'Terjadi kesalahan tidak diketahui';
    }
  }
}