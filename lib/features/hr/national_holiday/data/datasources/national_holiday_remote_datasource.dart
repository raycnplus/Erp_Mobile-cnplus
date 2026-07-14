import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/models/national_holiday_models.dart';

class NationalHolidayRemoteDataSource {
  final Dio dio;

  NationalHolidayRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getHolidayList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get(
        '/hr/national-holidays',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final paginatedData = json['data'] as Map<String, dynamic>;
      final items = paginatedData['data'] as List<dynamic>? ?? [];
      return {
        'items': items.map((e) => NationalHolidayModel.fromJson(e)).toList(),
        'meta': NationalHolidayPaginationMeta(
          currentPage: paginatedData['current_page'] ?? 1,
          lastPage: paginatedData['last_page'] ?? 1,
          perPage: paginatedData['per_page'] ?? 15,
          total: paginatedData['total'] ?? 0,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<NationalHolidayDetailModel> getHolidayDetail(String encryption) async {
    try {
      final response = await dio.get('/hr/national-holidays/$encryption');
      return NationalHolidayDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> createHoliday(NationalHolidayFormModel formData) async {
    try {
      await dio.post('/hr/national-holidays', data: formData.toJson());
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> updateHoliday(String encryption, NationalHolidayFormModel formData) async {
    try {
      final response = await dio.put(
        '/hr/national-holidays/$encryption',
        data: formData.toJson(),
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> deleteHoliday(String encryption) async {
    try {
      await dio.delete('/hr/national-holidays/$encryption');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) =>
      e.response?.data['message'] ?? 'Network error: ${e.message}';
}