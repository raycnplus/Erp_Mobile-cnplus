import '../../domain/entities/attendance_entity.dart';

class AttendanceDataModel {
  final EmployeeModel employee;
  final TodayAttendanceModel? todayAttendance;
  final List<RecentAttendanceModel> recentAttendance;
  final AttendanceStatsModel stats;
  final LocationConfigModel locationConfig;
  final String checkInLimit;

  AttendanceDataModel({
    required this.employee,
    this.todayAttendance,
    required this.recentAttendance,
    required this.stats,
    required this.locationConfig,
    required this.checkInLimit,
  });

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AttendanceDataModel(
      employee: EmployeeModel.fromJson(data['employee']),
      todayAttendance: data['today_attendance'] != null
          ? TodayAttendanceModel.fromJson(data['today_attendance'])
          : null,
      recentAttendance: (data['recent_attendance'] as List)
          .map((e) => RecentAttendanceModel.fromJson(e))
          .toList(),
      stats: AttendanceStatsModel.fromJson(data['stats']),
      locationConfig: LocationConfigModel.fromJson(data['location_config']),
      checkInLimit: data['check_in_limit'] ?? '08:10',
    );
  }

  AttendanceDataEntity toEntity() => AttendanceDataEntity(
        employee: employee.toEntity(),
        todayAttendance: todayAttendance?.toEntity(),
        recentAttendance: recentAttendance.map((e) => e.toEntity()).toList(),
        stats: stats.toEntity(),
        locationConfig: locationConfig.toEntity(),
        checkInLimit: checkInLimit,
      );
}

class EmployeeModel {
  final int id;
  final String name;
  final String email;

  EmployeeModel({required this.id, required this.name, required this.email});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: _parseInt(json['id']) ?? 0,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );

  EmployeeEntity toEntity() =>
      EmployeeEntity(id: id, name: name, email: email);
}

class TodayAttendanceModel {
  final int id;
  final String attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;
  final String? status;
  final double? workingHours;
  final String? checkInPhoto;
  final String? checkOutPhoto;

  TodayAttendanceModel({
    required this.id,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.status,
    this.workingHours,
    this.checkInPhoto,
    this.checkOutPhoto,
  });

  factory TodayAttendanceModel.fromJson(Map<String, dynamic> json) =>
      TodayAttendanceModel(
        id: _parseInt(json['id']) ?? 0,
        attendanceDate: json['attendance_date'] as String? ?? '',
        checkInTime: json['check_in_time'] as String?,
        checkOutTime: json['check_out_time'] as String?,
        status: json['status'] as String?,
        workingHours: _parseDouble(json['working_hours']),
        checkInPhoto: json['check_in_photo'] as String?,
        checkOutPhoto: json['check_out_photo'] as String?,
      );

  TodayAttendanceEntity toEntity() => TodayAttendanceEntity(
        id: id,
        attendanceDate: attendanceDate,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        status: status,
        workingHours: workingHours,
        checkInPhoto: checkInPhoto,
        checkOutPhoto: checkOutPhoto,
      );
}

class RecentAttendanceModel {
  final int id;
  final String attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;
  final String? status;
  final double? workingHours;

  RecentAttendanceModel({
    required this.id,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.status,
    this.workingHours,
  });

  factory RecentAttendanceModel.fromJson(Map<String, dynamic> json) =>
      RecentAttendanceModel(
        id: _parseInt(json['id']) ?? 0,
        attendanceDate: json['attendance_date'] as String? ?? '',
        checkInTime: json['check_in_time'] as String?,
        checkOutTime: json['check_out_time'] as String?,
        status: json['status'] as String?,
        workingHours: _parseDouble(json['working_hours']),
      );

  RecentAttendanceEntity toEntity() => RecentAttendanceEntity(
        id: id,
        attendanceDate: attendanceDate,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        status: status,
        workingHours: workingHours,
      );
}

class AttendanceStatsModel {
  final int total;
  final int present;
  final int late;
  final int absent;
  final double avgHours;

  AttendanceStatsModel({
    required this.total,
    required this.present,
    required this.late,
    required this.absent,
    required this.avgHours,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) =>
    AttendanceStatsModel(
      total: _parseInt(json['total']) ?? 0,
      present: _parseInt(json['present']) ?? 0,
      late: _parseInt(json['late']) ?? 0,
      absent: _parseInt(json['absent']) ?? 0,
      avgHours: _parseDouble(json['avg_hours']) ?? 0.0,  // ganti
    );

  AttendanceStatsEntity toEntity() => AttendanceStatsEntity(
        total: total,
        present: present,
        late: late,
        absent: absent,
        avgHours: avgHours,
      );
}

class LocationConfigModel {
  final double lat;
  final double lng;
  final String? address;
  final int radius;

  LocationConfigModel({
    required this.lat,
    required this.lng,
    this.address,
    required this.radius,
  });

  factory LocationConfigModel.fromJson(Map<String, dynamic> json) =>
    LocationConfigModel(
      lat: _parseDouble(json['lat']) ?? 0.0,      // ganti dari (json['lat'] as num?)
      lng: _parseDouble(json['lng']) ?? 0.0,      // ganti dari (json['lng'] as num?)
      address: json['address'] as String?,
      radius: _parseInt(json['radius']) ?? 100,
    );

  LocationConfigEntity toEntity() => LocationConfigEntity(
        lat: lat,
        lng: lng,
        address: address,
        radius: radius,
      );
}

class AttendanceHistoryModel {
  final List<RecentAttendanceModel> attendances;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  AttendanceHistoryModel({
    required this.attendances,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>;
    return AttendanceHistoryModel(
      attendances: (data['attendances'] as List)
          .map((e) => RecentAttendanceModel.fromJson(e))
          .toList(),
      total: _parseInt(pagination['total']) ?? 0,
      perPage: _parseInt(pagination['per_page']) ?? 15,
      currentPage: _parseInt(pagination['current_page']) ?? 1,
      lastPage: _parseInt(pagination['last_page']) ?? 1,
    );
  }

  AttendanceHistoryEntity toEntity() => AttendanceHistoryEntity(
        attendances: attendances.map((e) => e.toEntity()).toList(),
        total: total,
        perPage: perPage,
        currentPage: currentPage,
        lastPage: lastPage,
      );
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}