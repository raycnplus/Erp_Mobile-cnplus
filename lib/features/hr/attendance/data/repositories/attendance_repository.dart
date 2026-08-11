import '../../domain/entities/attendance_entity.dart';
import '../datasources/attendance_remote_datasource.dart';

class AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepository({required this.remoteDataSource});

  Future<AttendanceDataEntity> getAttendanceData() async {
    final model = await remoteDataSource.getAttendanceData();
    return model.toEntity();
  }

  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) async {
    return remoteDataSource.checkIn(
      latitude: latitude,
      longitude: longitude,
      photoBase64: photoBase64,
    );
  }

  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) async {
    return remoteDataSource.checkOut(
      latitude: latitude,
      longitude: longitude,
      photoBase64: photoBase64,
    );
  }

  Future<AttendanceHistoryEntity> getHistory({
    int page = 1,
    int? month,
    int? year,
  }) async {
    final model = await remoteDataSource.getHistory(
      page: page,
      month: month,
      year: year,
    );
    return model.toEntity();
  }
}