import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/models/leave_allocation_models.dart';

class LeaveAllocationRemoteDataSource {
  final Dio dio;

  LeaveAllocationRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    int? year,
  }) async {
    try {
      final r = await dio.get(
        '/hr/leave-allocations',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (year != null) 'year': year,
        },
      );

      final json = r.data as Map<String, dynamic>;
      final pd = json['data'] as Map<String, dynamic>;

      return {
        'items': (pd['data'] as List)
            .map(
              (e) => LeaveAllocationModel.fromJson(e),
            )
            .toList(),
        'meta': LeaveAllocationPaginationMeta(
          currentPage: pd['current_page'] ?? 1,
          lastPage: pd['last_page'] ?? 1,
          perPage: pd['per_page'] ?? 15,
          total: pd['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<LeaveAllocationDetailModel> getDetail(
    String encryption,
  ) async {
    try {
      final r = await dio.get(
        '/hr/leave-allocations/$encryption',
      );

      return LeaveAllocationDetailModel.fromJson(
        r.data,
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<LeaveAllocationFormOptions>
      getFormOptions() async {
    try {
      final r = await dio.get(
        '/hr/leave-allocations/form-options',
      );

      return LeaveAllocationFormOptions.fromJson(
        r.data,
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> create(
    LeaveAllocationFormModel formData,
  ) async {
    try {
      await dio.post(
        '/hr/leave-allocations',
        data: formData.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String encryption,
    LeaveAllocationFormModel formData,
  ) async {
    try {
      final r = await dio.put(
        '/hr/leave-allocations/$encryption',
        data: formData.toJson(),
      );

      final data = r.data;

      if (data is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner is Map<String, dynamic> &&
            inner['encryption'] != null) {
          return inner['encryption'] as String;
        }
      }

      return encryption;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(
    String encryptionOrId,
  ) async {
    try {
      await dio.delete(
        '/hr/leave-allocations/$encryptionOrId',
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ??
      e.response?.data?.toString() ??
      'Network error: ${e.message}';
}