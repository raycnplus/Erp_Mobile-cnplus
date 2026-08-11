import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/data/models/leave_quota_models.dart';

class LeaveQuotaRemoteDataSource {
  final Dio dio;

  LeaveQuotaRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 15,
    String? period,
    String? showType,
  }) async {
    try {
      final response = await dio.get(
        '/hr/leave-quotas',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (period != null) 'period': period,
          if (showType != null)
            'show_type': showType,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final data =
          json['data'] as Map<String, dynamic>;

      return {
        'items': (data['data'] as List)
            .map(
              (item) => LeaveQuotaModel.fromJson(
                item,
              ),
            )
            .toList(),
        'meta': LeaveQuotaPaginationMeta(
          currentPage: data['current_page'] ?? 1,
          lastPage: data['last_page'] ?? 1,
          perPage: data['per_page'] ?? 15,
          total: data['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<Map<String, dynamic>> getDetail(
    String employeeEncryption,
    int leaveTypeId, {
    String? period,
  }) async {
    try {
      final response = await dio.get(
        '/hr/leave-quotas/$employeeEncryption/$leaveTypeId',
        queryParameters: {
          if (period != null) 'period': period,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<Map<String, dynamic>> getHistory(
    String employeeEncryption,
    int leaveTypeId, {
    int page = 1,
    int perPage = 15,
    String? period,
  }) async {
    try {
      final response = await dio.get(
        '/hr/leave-quotas/$employeeEncryption/$leaveTypeId/history',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (period != null) 'period': period,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      final data =
          json['data'] as Map<String, dynamic>;

      return {
        'items': (data['data'] as List)
            .map(
              (item) => LeaveHistoryModel.fromJson(
                item,
              ),
            )
            .toList(),
        'meta': LeaveQuotaPaginationMeta(
          currentPage: data['current_page'] ?? 1,
          lastPage: data['last_page'] ?? 1,
          perPage: data['per_page'] ?? 15,
          total: data['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  String _getErrorMessage(DioException e) {
    return e.response?.data?['message'] ??
        e.response?.data?.toString() ??
        'Network error';
  }
}