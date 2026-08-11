class AttendanceDataEntity {
  final EmployeeEntity employee;
  final TodayAttendanceEntity? todayAttendance;
  final List<RecentAttendanceEntity> recentAttendance;
  final AttendanceStatsEntity stats;
  final LocationConfigEntity locationConfig;
  final String checkInLimit;

  AttendanceDataEntity({
    required this.employee,
    this.todayAttendance,
    required this.recentAttendance,
    required this.stats,
    required this.locationConfig,
    required this.checkInLimit,
  });
}

class EmployeeEntity {
  final int id;
  final String name;
  final String email;

  EmployeeEntity({required this.id, required this.name, required this.email});
}

class TodayAttendanceEntity {
  final int id;
  final String attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;
  final String? status;
  final double? workingHours;
  final String? checkInPhoto;
  final String? checkOutPhoto;

  TodayAttendanceEntity({
    required this.id,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.status,
    this.workingHours,
    this.checkInPhoto,
    this.checkOutPhoto,
  });
}

class RecentAttendanceEntity {
  final int id;
  final String attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;
  final String? status;
  final double? workingHours;

  RecentAttendanceEntity({
    required this.id,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.status,
    this.workingHours,
  });
}

class AttendanceStatsEntity {
  final int total;
  final int present;
  final int late;
  final int absent;
  final double avgHours;

  AttendanceStatsEntity({
    required this.total,
    required this.present,
    required this.late,
    required this.absent,
    required this.avgHours,
  });
}

class LocationConfigEntity {
  final double lat;
  final double lng;
  final String? address;
  final int radius;

  LocationConfigEntity({
    required this.lat,
    required this.lng,
    this.address,
    required this.radius,
  });
}

class AttendanceHistoryEntity {
  final List<RecentAttendanceEntity> attendances;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  AttendanceHistoryEntity({
    required this.attendances,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });
}