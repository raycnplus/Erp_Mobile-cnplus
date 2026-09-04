import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/models/attendance_overtime_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/domain/usecases/attendance_overtime_report_usecases.dart';

class AttendanceOvertimeReportController
    extends ChangeNotifier {
  final GetAttendanceOvertimeReportList
      getAttendanceOvertimeReportList;

  final GetAttendanceOvertimeReportFormOptions
      getAttendanceOvertimeReportFormOptions;

  AttendanceOvertimeReportController({
    required this.getAttendanceOvertimeReportList,
    required this.getAttendanceOvertimeReportFormOptions,
  });

  // ============================================================
  // LIST STATE
  // ============================================================

  List<AttendanceOvertimeReportModel> _list = [];

  bool _isLoadingList = false;

  String? _listError;

  AttendanceOvertimeReportSummary? _summary;

  AttendanceOvertimeReportSettings? _settings;

  bool _hasFetchedOnce = false;

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  List<AttendanceOvertimeReportEmployeeOption>
      _employeeOptions = [];

  List<AttendanceOvertimeReportDepartmentOption>
      _departmentOptions = [];

  bool _isLoadingOptions = false;

  String? _optionsError;

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

  List<AttendanceOvertimeReportModel> get list =>
      _list;

  bool get isLoadingList =>
      _isLoadingList;

  String? get listError =>
      _listError;

  AttendanceOvertimeReportSummary? get summary =>
      _summary;

  AttendanceOvertimeReportSettings? get settings =>
      _settings;

  bool get hasFetchedOnce =>
      _hasFetchedOnce;

  List<AttendanceOvertimeReportEmployeeOption>
      get employeeOptions =>
          _employeeOptions;

  List<AttendanceOvertimeReportDepartmentOption>
      get departmentOptions =>
          _departmentOptions;

  bool get isLoadingOptions =>
      _isLoadingOptions;

  String? get optionsError =>
      _optionsError;

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
  // DATE FORMAT
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
          await getAttendanceOvertimeReportFormOptions();

      _employeeOptions =
          options.employees;

      _departmentOptions =
          options.departments;

      _settings =
          options.settings;
    } catch (e) {
      _optionsError =
          _extractMessage(e);

      _employeeOptions = [];

      _departmentOptions = [];
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
          await getAttendanceOvertimeReportList(
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
              as List<AttendanceOvertimeReportModel>;

      _summary =
          result['summary']
              as AttendanceOvertimeReportSummary;

      _settings =
          result['settings']
              as AttendanceOvertimeReportSettings;
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
  // APPLY FILTER
  // ============================================================

  void applyFilter() {
    fetchList();
  }

  // ============================================================
  // RESET FILTER
  // ============================================================

  void resetFilter() {
    _selectedEmployeeId = null;
    _selectedDepartmentId = null;
    _dateFrom = null;
    _dateTo = null;

    _list = [];
    _summary = null;
    _settings = null;

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