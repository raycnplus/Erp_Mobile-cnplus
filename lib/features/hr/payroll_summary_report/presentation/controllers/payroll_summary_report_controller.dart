import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/models/payroll_summary_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/domain/usecases/payroll_summary_report_usecases.dart';

class PayrollSummaryReportController
    extends ChangeNotifier {
  final GetPayrollSummaryReportList
      getPayrollSummaryReportList;

  final GetPayrollSummaryReportFormOptions
      getPayrollSummaryReportFormOptions;

  PayrollSummaryReportController({
    required this.getPayrollSummaryReportList,
    required this.getPayrollSummaryReportFormOptions,
  });

  // ============================================================
  // LIST
  // ============================================================

  List<PayrollSummaryReportModel> _list = [];

  bool _isLoadingList = false;

  String? _listError;

  PayrollSummaryReportSummary? _summary;

  bool _hasFetchedOnce = false;

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  List<PayrollSummaryReportPayrollPeriodOption>
      _payrollPeriodOptions = [];

  List<PayrollSummaryReportDepartmentOption>
      _departmentOptions = [];

  bool _isLoadingOptions = false;

  String? _optionsError;

  // ============================================================
  // FILTER
  // ============================================================

  int? _selectedPayrollPeriodId;

  int? _selectedDepartmentId;

  // ============================================================
  // GETTERS
  // ============================================================

  List<PayrollSummaryReportModel> get list =>
      _list;

  bool get isLoadingList =>
      _isLoadingList;

  String? get listError =>
      _listError;

  PayrollSummaryReportSummary? get summary =>
      _summary;

  bool get hasFetchedOnce =>
      _hasFetchedOnce;

  List<PayrollSummaryReportPayrollPeriodOption>
      get payrollPeriodOptions =>
          _payrollPeriodOptions;

  List<PayrollSummaryReportDepartmentOption>
      get departmentOptions =>
          _departmentOptions;

  bool get isLoadingOptions =>
      _isLoadingOptions;

  String? get optionsError =>
      _optionsError;

  int? get selectedPayrollPeriodId =>
      _selectedPayrollPeriodId;

  int? get selectedDepartmentId =>
      _selectedDepartmentId;

  bool get hasActiveFilter =>
      _selectedPayrollPeriodId != null ||
      _selectedDepartmentId != null;

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
          await getPayrollSummaryReportFormOptions();

      _payrollPeriodOptions =
          options.payrollPeriods;

      _departmentOptions =
          options.departments;
    } catch (e) {
      _optionsError =
          _extractMessage(e);

      _payrollPeriodOptions = [];
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
    if (_selectedPayrollPeriodId == null) {
      _listError =
          'Payroll Period is required.';

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
          await getPayrollSummaryReportList(
        payrollPeriodId:
            _selectedPayrollPeriodId!,
        departmentId:
            _selectedDepartmentId,
      );

      _list =
          result['items']
              as List<PayrollSummaryReportModel>;

      _summary =
          result['summary']
              as PayrollSummaryReportSummary;
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

  void selectPayrollPeriod(
    int? idPayrollPeriod,
  ) {
    _selectedPayrollPeriodId =
        idPayrollPeriod;

    notifyListeners();
  }

  void selectDepartment(
    int? idDepartment,
  ) {
    _selectedDepartmentId =
        idDepartment;

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
    _selectedPayrollPeriodId = null;

    _selectedDepartmentId = null;

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