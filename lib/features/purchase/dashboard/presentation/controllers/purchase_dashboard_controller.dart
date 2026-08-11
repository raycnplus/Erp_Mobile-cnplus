import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/data/models/purchase_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/domain/usecases/get_purchase_dashboard_data.dart';

enum PurchaseDashboardStatus { initial, loading, loaded, error }

class PurchaseDashboardController extends ChangeNotifier {
  final GetPurchaseDashboardData _getDashboardData;

  PurchaseDashboardController({required GetPurchaseDashboardData getDashboardData})
      : _getDashboardData = getDashboardData;

  PurchaseDashboardStatus    _status       = PurchaseDashboardStatus.initial;
  String?                    _errorMessage;
  PurchaseDashboardResponse? _dashboardData;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate   = DateTime.now();

  PurchaseDashboardStatus    get status       => _status;
  String?                    get errorMessage => _errorMessage;
  PurchaseDashboardResponse? get dashboardData => _dashboardData;
  bool                       get isLoading    => _status == PurchaseDashboardStatus.loading;
  bool                       get hasData      => _dashboardData != null;
  DateTime                   get startDate    => _startDate;
  DateTime                   get endDate      => _endDate;

  Future<void> loadDashboard({DateTime? start, DateTime? end}) async {
    if (start != null) _startDate = start;
    if (end != null)   _endDate   = end;

    _status = PurchaseDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getDashboardData.execute(
      startDate: '${_startDate.year}-${_startDate.month.toString().padLeft(2,'0')}-${_startDate.day.toString().padLeft(2,'0')}',
      endDate:   '${_endDate.year}-${_endDate.month.toString().padLeft(2,'0')}-${_endDate.day.toString().padLeft(2,'0')}',
    );

    if (result['success'] == true) {
      _dashboardData = result['data'] as PurchaseDashboardResponse;
      _status        = PurchaseDashboardStatus.loaded;
    } else {
      _status       = PurchaseDashboardStatus.error;
      _errorMessage = result['message'] ?? 'Failed to load dashboard';
    }
    notifyListeners();
  }

  Future<void> refresh() => loadDashboard();
}