import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/data/models/leave_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/domain/usecases/leave_report_usecases.dart';

class LeaveReportController
    extends ChangeNotifier {
  final GetLeaveReportList getLeaveReportList;

  final GetLeaveReportFormOptions
      getLeaveReportFormOptions;

  LeaveReportController({
    required this.getLeaveReportList,
    required this.getLeaveReportFormOptions,
  });

  // ============================================================
  // LIST
  // ============================================================

  List<LeaveReportModel> _list = [];

  bool _isLoadingList = false;

  String? _listError;

  LeaveReportSummary? _summary;

  bool _hasFetchedOnce = false;

  // ============================================================
  // OPTIONS
  // ============================================================

  List<LeaveReportEmployeeOption>
      _employeeOptions = [];

  List<LeaveReportDepartmentOption>
      _departmentOptions = [];

  List<LeaveReportLeaveTypeOption>
      _leaveTypeOptions = [];

  bool _isLoadingOptions = false;

  String? _optionsError;

  // ============================================================
  // FILTER
  // ============================================================

  int? _selectedEmployeeId;

  int? _selectedDepartmentId;

  int? _selectedLeaveTypeId;

  DateTime? _dateFrom;

  DateTime? _dateTo;

  // ============================================================
  // GETTERS
  // ============================================================

  List<LeaveReportModel> get list =>
      _list;

  bool get isLoadingList =>
      _isLoadingList;

  String? get listError =>
      _listError;

  LeaveReportSummary? get summary =>
      _summary;

  bool get hasFetchedOnce =>
      _hasFetchedOnce;

  List<LeaveReportEmployeeOption>
      get employeeOptions =>
          _employeeOptions;

  List<LeaveReportDepartmentOption>
      get departmentOptions =>
          _departmentOptions;

  List<LeaveReportLeaveTypeOption>
      get leaveTypeOptions =>
          _leaveTypeOptions;

  bool get isLoadingOptions =>
      _isLoadingOptions;

  String? get optionsError =>
      _optionsError;

  int? get selectedEmployeeId =>
      _selectedEmployeeId;

  int? get selectedDepartmentId =>
      _selectedDepartmentId;

  int? get selectedLeaveTypeId =>
      _selectedLeaveTypeId;

  DateTime? get dateFrom =>
      _dateFrom;

  DateTime? get dateTo =>
      _dateTo;

  bool get hasActiveFilter =>
      _selectedEmployeeId != null ||
      _selectedDepartmentId != null ||
      _selectedLeaveTypeId != null ||
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
          await getLeaveReportFormOptions();

      _employeeOptions =
          options.employees;

      _departmentOptions =
          options.departments;

      _leaveTypeOptions =
          options.leaveTypes;
    } catch (e) {
      _optionsError =
          _extractMessage(e);

      _employeeOptions = [];
      _departmentOptions = [];
      _leaveTypeOptions = [];
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
          await getLeaveReportList(
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
        leaveTypeId:
            _selectedLeaveTypeId,
      );

      _list =
          result['items']
              as List<LeaveReportModel>;

      _summary =
          result['summary']
              as LeaveReportSummary;
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

  void selectLeaveType(
    int? idLeaveType,
  ) {
    _selectedLeaveTypeId =
        idLeaveType;

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
    _selectedLeaveTypeId = null;

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