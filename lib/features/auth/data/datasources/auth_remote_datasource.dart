import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/core/network/dio_client.dart';
import 'package:erp_mobile_cnplus/core/config/app_config.dart';
import 'package:erp_mobile_cnplus/features/auth/data/models/login_response.dart';
import 'package:erp_mobile_cnplus/features/auth/data/models/login_request.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<LoginResponse> refreshToken(String oldToken, String database);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        AppConfig.loginEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error during login: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dioClient.dio.post(AppConfig.logoutEndpoint);
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: response.data['message'] ?? 'Logout failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error during logout: $e');
    }
  }

  @override
  Future<LoginResponse> refreshToken(String oldToken, String database) async {
    try {
      final response = await _dioClient.dio.post(
        AppConfig.refreshEndpoint,
        data: {
          'token': oldToken,
          'database': database,
        },
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: response.data['message'] ?? 'Refresh token failed',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error during token refresh: $e');
    }
  }
}