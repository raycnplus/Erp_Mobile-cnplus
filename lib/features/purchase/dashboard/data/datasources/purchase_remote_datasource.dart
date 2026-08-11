import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/core/network/dio_client.dart';

abstract class PurchaseRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData({String? startDate, String? endDate});
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  final DioClient _dioClient;
  PurchaseRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> getDashboardData({String? startDate, String? endDate}) async {
    try {
      final response = await _dioClient.dio.get(
        '/purchase/',
        queryParameters: {
          if (startDate != null) 'start_date': startDate,
          if (endDate != null)   'end_date':   endDate,
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
    } on DioException { rethrow; }
    catch (e) { throw Exception('Unexpected error: $e'); }
  }
}