import 'package:dio/dio.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceDataModel> getAttendanceData();
  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    required String photoBase64,
  });
  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
    required String photoBase64,
  });
  Future<AttendanceHistoryModel> getHistory({int page = 1, int? month, int? year});
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio dio;

  AttendanceRemoteDataSourceImpl(this.dio);

  @override
  Future<AttendanceDataModel> getAttendanceData() async {
    final response = await dio.get('/hr/attendance');
    if (response.statusCode == 200 && response.data['success'] == true) {
      return AttendanceDataModel.fromJson(response.data);
    }
    throw Exception(response.data['message'] ?? 'Failed to get attendance data');
  }

  @override
  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) async {
    final response = await dio.post(
      '/hr/attendance/check-in',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'photo': photoBase64,
      },
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    }
    throw Exception(response.data['message'] ?? 'Check-in failed');
  }

  @override
  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) async {
    final response = await dio.post(
      '/hr/attendance/check-out',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'photo': photoBase64,
      },
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    }
    throw Exception(response.data['message'] ?? 'Check-out failed');
  }

  @override
  Future<AttendanceHistoryModel> getHistory({
    int page = 1,
    int? month,
    int? year,
  }) async {
    final response = await dio.get(
      '/hr/attendance/history',
      queryParameters: {
        'page': page,
        if (month != null) 'month': month,
        if (year != null) 'year': year,
      },
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      return AttendanceHistoryModel.fromJson(response.data);
    }
    throw Exception(response.data['message'] ?? 'Failed to get history');
  }
}