import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/models/accounting_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/domain/usecases/get_accounting_dashboard.dart';

enum AccountingDashboardStatus { initial, loading, loaded, error }

class AccountingDashboardController extends ChangeNotifier {
  final GetAccountingDashboardData _getDashboardData;

  AccountingDashboardController({required GetAccountingDashboardData getDashboardData})
      : _getDashboardData = getDashboardData;

  AccountingDashboardStatus    _status       = AccountingDashboardStatus.initial;
  String?                      _errorMessage;
  AccountingDashboardResponse? _dashboardData;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate   = DateTime.now();

  AccountingDashboardStatus    get status       => _status;
  String?                      get errorMessage => _errorMessage;
  AccountingDashboardResponse? get dashboardData => _dashboardData;
  bool                         get isLoading    => _status == AccountingDashboardStatus.loading;
  bool                         get hasData      => _dashboardData != null;
  DateTime                     get startDate    => _startDate;
  DateTime                     get endDate      => _endDate;

  Future<void> loadDashboard({DateTime? start, DateTime? end}) async {
    if (start != null) _startDate = start;
    if (end != null)   _endDate   = end;

    _status = AccountingDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getDashboardData.execute(
      startDate: '${_startDate.year}-${_startDate.month.toString().padLeft(2,'0')}-${_startDate.day.toString().padLeft(2,'0')}',
      endDate:   '${_endDate.year}-${_endDate.month.toString().padLeft(2,'0')}-${_endDate.day.toString().padLeft(2,'0')}',
    );

    if (result['success'] == true) {
      _dashboardData = result['data'] as AccountingDashboardResponse;
      _status        = AccountingDashboardStatus.loaded;
    } else {
      _status       = AccountingDashboardStatus.error;
      _errorMessage = result['message'] ?? 'Failed to load dashboard';
    }
    notifyListeners();
  }

  Future<void> refresh() => loadDashboard();
  
  void updateDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    loadDashboard(start: start, end: end);
  }
}