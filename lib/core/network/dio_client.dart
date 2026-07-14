import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:erp_mobile_cnplus/core/config/app_config.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  
  late final Dio _dio;
  late final Dio _dioWithoutInterceptor;
  final _storage = const FlutterSecureStorage();
  
  bool _isRefreshing = false;
  final List<Function> _pendingRequests = [];
  
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    
    _dioWithoutInterceptor = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_loggerInterceptor());
  }
  
  Dio get dio => _dio;
  
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (options.data is FormData) {
          options.headers.remove('Content-Type');
          options.headers.remove('content-type');
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          if (_isRefreshing) {
            return _addRequestToQueue(error, handler);
          }
          
          try {
            _isRefreshing = true;
            final newToken = await _refreshToken();
            
            if (newToken != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final response = await _retryRequest(error.requestOptions);
              _processPendingRequests(newToken);
              return handler.resolve(response);
            } else {
              await _clearAuthAndReject();
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: 'Token refresh failed. Please login again.',
                  type: DioExceptionType.badResponse,
                ),
              );
            }
          } catch (e) {
            await _clearAuthAndReject();
            return handler.next(error);
          } finally {
            _isRefreshing = false;
          }
        }
        return handler.next(error);
      },
    );
  }
  
  Future<void> _addRequestToQueue(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    _pendingRequests.add(() async {
      try {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          error.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _retryRequest(error.requestOptions);
          handler.resolve(response);
        } else {
          handler.next(error);
        }
      } catch (e) {
        handler.next(error);
      }
    });
  }
  
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final opts = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    
    return await _dio.request(
      requestOptions.path,
      options: opts,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }
  
  void _processPendingRequests(String newToken) {
    for (var request in _pendingRequests) {
      request();
    }
    _pendingRequests.clear();
  }
  
  Future<void> _clearAuthAndReject() async {
    await _storage.deleteAll();
    _pendingRequests.clear();
  }
  
  InterceptorsWrapper _loggerInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // print('🌐 REQUEST[${options.method}] => ${options.path}');
        // print('Headers: ${options.headers}');
        if (options.data != null) {
          if (options.data is Map) {
            final data = Map.from(options.data);
            if (data.containsKey('password')) {
              data['password'] = '***';
            }
            // print('Data: $data');
          } else {
            // print('Data: ${options.data}');
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        // print('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
        // print('Message: ${error.message}');
        if (error.response?.data != null) {
          // print('Response: ${error.response?.data}');
        }
        return handler.next(error);
      },
    );
  }
  
  Future<String?> _refreshToken() async {
    try {
      final oldToken = await _storage.read(key: 'token');
      final database = await _storage.read(key: 'database') ?? 'mysql';
      
      if (oldToken == null) return null;
      
      final response = await _dioWithoutInterceptor.post(
        AppConfig.refreshEndpoint,
        data: {
          'token': oldToken,
          'database': database,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200 && response.data['token'] != null) {
        final newToken = response.data['token'] as String;
        await _storage.write(key: 'token', value: newToken);
        
        if (response.data['user'] != null) {
          final user = response.data['user'];
          if (user['username'] != null) {
            await _storage.write(key: 'username', value: user['username']);
          }
          if (user['email'] != null) {
            await _storage.write(key: 'email', value: user['email']);
          }
          if (user['nama_lengkap'] != null) {
            await _storage.write(key: 'nama_lengkap', value: user['nama_lengkap']);
          }
        }
        
        return newToken;
      }
      
      return null;
    } on DioException catch (e) {
      // print('❌ Refresh token DioException: ${e.message}');
      return null;
    } catch (e) {
      // print('❌ Refresh token error: $e');
      return null;
    }
  }
  
  Future<void> clearAuth() async {
    _isRefreshing = false;
    _pendingRequests.clear();
    await _storage.deleteAll();
  }
}