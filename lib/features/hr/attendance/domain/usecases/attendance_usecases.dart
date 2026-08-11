import '../../data/repositories/attendance_repository.dart';
import '../entities/attendance_entity.dart';

class GetAttendanceData {
  final AttendanceRepository repository;
  GetAttendanceData(this.repository);

  Future<AttendanceDataEntity> call() => repository.getAttendanceData();
}

class CheckIn {
  final AttendanceRepository repository;
  CheckIn(this.repository);

  Future<Map<String, dynamic>> call({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) =>
      repository.checkIn(
        latitude: latitude,
        longitude: longitude,
        photoBase64: photoBase64,
      );
}

class CheckOut {
  final AttendanceRepository repository;
  CheckOut(this.repository);

  Future<Map<String, dynamic>> call({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) =>
      repository.checkOut(
        latitude: latitude,
        longitude: longitude,
        photoBase64: photoBase64,
      );
}

class GetAttendanceHistory {
  final AttendanceRepository repository;
  GetAttendanceHistory(this.repository);

  Future<AttendanceHistoryEntity> call({
    int page = 1,
    int? month,
    int? year,
  }) =>
      repository.getHistory(page: page, month: month, year: year);
}