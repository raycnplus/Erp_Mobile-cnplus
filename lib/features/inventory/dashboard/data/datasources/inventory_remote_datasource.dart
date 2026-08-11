import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/core/network/dio_client.dart';

abstract class InventoryRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData({
    String? startDate,
    String? endDate,
  });
}

class InventoryRemoteDataSourceImpl
    implements InventoryRemoteDataSource {
  final DioClient _dioClient;

  InventoryRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> getDashboardData({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/inventory/',
        queryParameters: {
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null ||
            (data is String && data.trim().isEmpty)) {
          throw Exception('Response kosong dari server');
        }

        if (data is Map<String, dynamic>) {
          return data;
        }

        if (data is String) {
          final decoded = jsonDecode(data);

          if (decoded is Map<String, dynamic>) {
            return decoded;
          }

          throw Exception(
            'JSON bukan object: ${decoded.runtimeType}',
          );
        }

        throw Exception(
          'Format tidak dikenal: ${data.runtimeType}',
        );
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Status ${response.statusCode}',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}