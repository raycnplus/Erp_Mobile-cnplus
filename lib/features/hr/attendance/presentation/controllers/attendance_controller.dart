import 'package:flutter/foundation.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/attendance_usecases.dart';

enum AttendanceState { initial, loading, loaded, error }

class AttendanceController extends ChangeNotifier {
  final GetAttendanceData getAttendanceData;
  final CheckIn checkInUseCase;
  final CheckOut checkOutUseCase;
  final GetAttendanceHistory getAttendanceHistory;

  AttendanceController({
    required this.getAttendanceData,
    required this.checkInUseCase,
    required this.checkOutUseCase,
    required this.getAttendanceHistory,
  });

  AttendanceState _state = AttendanceState.initial;
  AttendanceDataEntity? _data;
  AttendanceHistoryEntity? _history;
  String? _errorMessage;
  bool _isSubmitting = false;

  AttendanceState get state => _state;
  AttendanceDataEntity? get data => _data;
  AttendanceHistoryEntity? get history => _history;
  String? get errorMessage => _errorMessage;
  bool get isSubmitting => _isSubmitting;

  TodayAttendanceEntity? get todayAttendance => _data?.todayAttendance;
  bool get hasCheckedIn => todayAttendance?.checkInTime != null;
  bool get hasCheckedOut => todayAttendance?.checkOutTime != null;

  Future<void> loadAttendanceData() async {
    _state = AttendanceState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _data = await getAttendanceData();
      _state = AttendanceState.loaded;
    } catch (e) {
      _state = AttendanceState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  Future<bool> performCheckIn({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await checkInUseCase(
        latitude: latitude,
        longitude: longitude,
        photoBase64: photoBase64,
      );
      await loadAttendanceData();
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> performCheckOut({
    required double latitude,
    required double longitude,
    required String photoBase64,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await checkOutUseCase(
        latitude: latitude,
        longitude: longitude,
        photoBase64: photoBase64,
      );
      await loadAttendanceData();
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> loadHistory({int page = 1, int? month, int? year}) async {
    try {
      _history = await getAttendanceHistory(
          page: page, month: month, year: year);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}