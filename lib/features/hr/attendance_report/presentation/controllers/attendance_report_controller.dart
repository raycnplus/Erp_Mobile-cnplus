import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/models/attendance_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_report/domain/usecases/attendance_report_usecases.dart';

class AttendanceReportController
    extends ChangeNotifier {
  final GetAttendanceReportList
      getAttendanceReportList;

  final GetAttendanceReportFormOptions
      getAttendanceReportFormOptions;

  AttendanceReportController({
    required this.getAttendanceReportList,
    required this.getAttendanceReportFormOptions,
  });

  // ============================================================
  // LIST
  // ============================================================

  List<AttendanceReportModel> _list = [];

  bool _isLoadingList = false;

  String? _listError;

  AttendanceReportSummary? _summary;

  bool _hasFetchedOnce = false;

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  List<AttendanceReportEmployeeOption>
      _employeeOptions = [];

  List<AttendanceReportDepartmentOption>
      _departmentOptions = [];

  List<String> _statuses = [];

  bool _isLoadingOptions = false;

  String? _optionsError;

  // ============================================================
  // FILTER
  // ============================================================

  int? _selectedEmployeeId;

  int? _selectedDepartmentId;

  String? _selectedStatus;

  DateTime? _dateFrom;

  DateTime? _dateTo;

  // ============================================================
  // PAGINATION
  // ============================================================

  int _currentPage = 1;

  int _lastPage = 1;

  int _total = 0;

  // ============================================================
  // GETTERS
  // ============================================================

  List<AttendanceReportModel> get list =>
      _list;

  bool get isLoadingList =>
      _isLoadingList;

  String? get listError =>
      _listError;

  AttendanceReportSummary? get summary =>
      _summary;

  bool get hasFetchedOnce =>
      _hasFetchedOnce;

  List<AttendanceReportEmployeeOption>
      get employeeOptions =>
          _employeeOptions;

  List<AttendanceReportDepartmentOption>
      get departmentOptions =>
          _departmentOptions;

  List<String> get statuses =>
      _statuses;

  bool get isLoadingOptions =>
      _isLoadingOptions;

  String? get optionsError =>
      _optionsError;

  int? get selectedEmployeeId =>
      _selectedEmployeeId;

  int? get selectedDepartmentId =>
      _selectedDepartmentId;

  String? get selectedStatus =>
      _selectedStatus;

  DateTime? get dateFrom =>
      _dateFrom;

  DateTime? get dateTo =>
      _dateTo;

  int get currentPage =>
      _currentPage;

  int get lastPage =>
      _lastPage;

  int get total =>
      _total;

  bool get hasPrevPage =>
      false;

  bool get hasNextPage =>
      false;

  bool get hasActiveFilter =>
      _selectedEmployeeId != null ||
      _selectedDepartmentId != null ||
      _selectedStatus != null ||
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
          await getAttendanceReportFormOptions();

      _employeeOptions =
          options.employees;

      _departmentOptions =
          options.departments;

      _statuses =
          options.statuses;
    } catch (e) {
      _optionsError =
          _extractMessage(e);

      _employeeOptions = [];
      _departmentOptions = [];
      _statuses = [];
    } finally {
      _isLoadingOptions = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FETCH LIST
  // ============================================================

  Future<void> fetchList() async {
    // Backend mewajibkan date range.
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
          await getAttendanceReportList(
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
        status:
            _selectedStatus,
      );

      _list =
          result['items']
              as List<AttendanceReportModel>;

      _summary =
          result['summary']
              as AttendanceReportSummary;

      final meta =
          result['meta']
              as AttendanceReportPaginationMeta;

      _currentPage =
          meta.currentPage;

      _lastPage =
          meta.lastPage;

      _total =
          meta.total;
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

  void selectStatus(
    String? status,
  ) {
    _selectedStatus =
        status;

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
    _currentPage = 1;

    fetchList();
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetFilter() {
    _selectedEmployeeId = null;

    _selectedDepartmentId = null;

    _selectedStatus = null;

    _dateFrom = null;

    _dateTo = null;

    _currentPage = 1;

    _list = [];

    _summary = null;

    _hasFetchedOnce = false;

    _listError = null;

    notifyListeners();
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  void goToPage(
    int page,
  ) {
    // Backend tidak menyediakan pagination.
    return;
  }

  void nextPage() {
    return;
  }

  void prevPage() {
    return;
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