import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/core/network/dio_client.dart';
import 'package:erp_mobile_cnplus/features/auth/domain/entities/user_entity.dart';
import 'package:erp_mobile_cnplus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:erp_mobile_cnplus/features/auth/data/models/login_request.dart';
import 'package:erp_mobile_cnplus/features/auth/data/models/login_response.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);
      
      await _localDataSource.saveToken(response.token);
      await _localDataSource.saveDatabase(request.database);
      
      if (response.user != null) {
        await _localDataSource.saveUserData(response.user!);
      }
      
      return {
        'success': true,
        'user': response.user != null ? _mapToEntity(response.user!) : null,
        'token': response.token,
      };
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

  Future<Map<String, dynamic>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearAll();
      
      // Clear dio client auth state
      final dioClient = DioClient();
      await dioClient.clearAuth();
      
      return {
        'success': true,
        'message': 'Berhasil logout',
      };
    } on DioException catch (e) {
      await _localDataSource.clearAll();
      final dioClient = DioClient();
      await dioClient.clearAuth();
      
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      await _localDataSource.clearAll();
      final dioClient = DioClient();
      await dioClient.clearAuth();
      
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final oldToken = await _localDataSource.getToken();
      final database = await _localDataSource.getDatabase() ?? 'mysql';
      
      if (oldToken == null) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan',
        };
      }
      
      final response = await _remoteDataSource.refreshToken(oldToken, database);
      
      await _localDataSource.saveToken(response.token);
      
      if (response.user != null) {
        await _localDataSource.saveUserData(response.user!);
      }
      
      return {
        'success': true,
        'user': response.user != null ? _mapToEntity(response.user!) : null,
        'token': response.token,
      };
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

  Future<bool> isLoggedIn() async {
    return await _localDataSource.hasToken();
  }

  Future<String?> getToken() async {
    return await _localDataSource.getToken();
  }

  Future<Map<String, String?>> getUserData() async {
    return await _localDataSource.getUserData();
  }

  UserEntity _mapToEntity(UserData userData) {
    return UserEntity(
      idUser: userData.idUser ?? 0,
      username: userData.username ?? '',
      namaLengkap: userData.namaLengkap ?? '',
      nomorTelepon: userData.nomorTelepon,
      email: userData.email,
      alamat: userData.alamat,
      image: userData.image,
      hashedImage: userData.hashedImage,
      gender: userData.gender,
      employeeName: userData.employeeName,
      departmentName: userData.departmentName,
      positionName: userData.positionName,
      employeeStatusName: userData.employeeStatusName,
    );
  }

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