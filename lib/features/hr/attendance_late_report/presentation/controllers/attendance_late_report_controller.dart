import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/models/attendance_late_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/domain/usecases/attendance_late_report_usecases.dart';

class AttendanceLateReportController
    extends ChangeNotifier {
  final GetAttendanceLateReportList
      getAttendanceLateReportList;

  final GetAttendanceLateReportFormOptions
      getAttendanceLateReportFormOptions;

  AttendanceLateReportController({
    required this.getAttendanceLateReportList,
    required this.getAttendanceLateReportFormOptions,
  });

  // ============================================================
  // LIST STATE
  // ============================================================

  List<AttendanceLateReportModel> _list = [];

  bool _isLoadingList = false;

  String? _listError;

  AttendanceLateReportSummary? _summary;

  bool _hasFetchedOnce = false;

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  List<AttendanceLateReportEmployeeOption>
      _employeeOptions = [];

  List<AttendanceLateReportDepartmentOption>
      _departmentOptions = [];

  bool _isLoadingOptions = false;

  String? _optionsError;

  String _scheduledIn = '08:00:00';

  // ============================================================
  // FILTER
  // ============================================================

  int? _selectedEmployeeId;

  int? _selectedDepartmentId;

  DateTime? _dateFrom;

  DateTime? _dateTo;

  // ============================================================
  // GETTERS
  // ============================================================

  List<AttendanceLateReportModel> get list =>
      _list;

  bool get isLoadingList =>
      _isLoadingList;

  String? get listError =>
      _listError;

  AttendanceLateReportSummary? get summary =>
      _summary;

  bool get hasFetchedOnce =>
      _hasFetchedOnce;

  List<AttendanceLateReportEmployeeOption>
      get employeeOptions =>
          _employeeOptions;

  List<AttendanceLateReportDepartmentOption>
      get departmentOptions =>
          _departmentOptions;

  bool get isLoadingOptions =>
      _isLoadingOptions;

  String? get optionsError =>
      _optionsError;

  String get scheduledIn =>
      _scheduledIn;

  int? get selectedEmployeeId =>
      _selectedEmployeeId;

  int? get selectedDepartmentId =>
      _selectedDepartmentId;

  DateTime? get dateFrom =>
      _dateFrom;

  DateTime? get dateTo =>
      _dateTo;

  bool get hasActiveFilter =>
      _selectedEmployeeId != null ||
      _selectedDepartmentId != null ||
      _dateFrom != null ||
      _dateTo != null;

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(
    DateTime d,
  ) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<void> fetchFormOptions() async {
    if (_isLoadingOptions) {
      return;
    }

    _isLoadingOptions = true;

    _optionsError = null;

    notifyListeners();

    try {
      final options =
          await getAttendanceLateReportFormOptions();

      _employeeOptions =
          options.employees;

      _departmentOptions =
          options.departments;

      _scheduledIn =
          options.scheduledIn;
    } catch (e) {
      _optionsError =
          _extractMessage(e);

      _employeeOptions = [];

      _departmentOptions = [];

      _scheduledIn = '08:00:00';
    } finally {
      _isLoadingOptions = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FETCH LIST
  // ============================================================

  Future<void> fetchList() async {
    if (_dateFrom == null ||
        _dateTo == null) {
      _listError =
          'From Date and To Date are required.';

      _hasFetchedOnce = true;

      notifyListeners();

      return;
    }

    _isLoadingList = true;

    _listError = null;

    _hasFetchedOnce = true;

    notifyListeners();

    try {
      final result =
          await getAttendanceLateReportList(
        dateFrom:
            _formatDate(
          _dateFrom!,
        ),
        dateTo:
            _formatDate(
          _dateTo!,
        ),
        employeeId:
            _selectedEmployeeId,
        departmentId:
            _selectedDepartmentId,
      );

      _list =
          result['items']
              as List<AttendanceLateReportModel>;

      _summary =
          result['summary']
              as AttendanceLateReportSummary;
    } catch (e) {
      _listError =
          _extractMessage(e);

      _list = [];
    } finally {
      _isLoadingList = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FILTER
  // ============================================================

  void selectEmployee(
    int? idEmployee,
  ) {
    _selectedEmployeeId =
        idEmployee;

    notifyListeners();
  }

  void selectDepartment(
    int? idDepartment,
  ) {
    _selectedDepartmentId =
        idDepartment;

    notifyListeners();
  }

  void setDateRange(
    DateTime? from,
    DateTime? to,
  ) {
    _dateFrom = from;

    _dateTo = to;

    notifyListeners();
  }

  // ============================================================
  // APPLY
  // ============================================================

  void applyFilter() {
    fetchList();
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetFilter() {
    _selectedEmployeeId = null;

    _selectedDepartmentId = null;

    _dateFrom = null;

    _dateTo = null;

    _list = [];

    _summary = null;

    _listError = null;

    _hasFetchedOnce = false;

    notifyListeners();
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _extractMessage(
    dynamic error,
  ) =>
      error
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
}