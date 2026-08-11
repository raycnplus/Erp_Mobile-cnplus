import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/core/network/dio_client.dart';

abstract class ManufacturingRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData({String? startDate, String? endDate});
}

class ManufacturingRemoteDataSourceImpl implements ManufacturingRemoteDataSource {
  final DioClient _dioClient;

  ManufacturingRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> getDashboardData({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/manufacturing/',
        queryParameters: {
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) return data;
        if (data is String) return jsonDecode(data) as Map<String, dynamic>;
        throw Exception('Unexpected format');
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}