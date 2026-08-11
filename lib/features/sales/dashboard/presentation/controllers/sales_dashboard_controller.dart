import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/models/sales_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/domain/usecases/get_sales_dashboard_data.dart';

enum SalesDashboardStatus { initial, loading, loaded, error }

class SalesDashboardController extends ChangeNotifier {
  final GetSalesDashboardData _getDashboardData;

  SalesDashboardController({required GetSalesDashboardData getDashboardData})
      : _getDashboardData = getDashboardData;

  SalesDashboardStatus    _status       = SalesDashboardStatus.initial;
  String?                 _errorMessage;
  SalesDashboardResponse? _dashboardData;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate   = DateTime.now();

  SalesDashboardStatus    get status        => _status;
  String?                 get errorMessage  => _errorMessage;
  SalesDashboardResponse? get dashboardData => _dashboardData;
  bool                    get isLoading     => _status == SalesDashboardStatus.loading;
  bool                    get hasData       => _dashboardData != null;
  DateTime                get startDate     => _startDate;
  DateTime                get endDate       => _endDate;

  void setDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate   = end;
  }

  Future<void> loadDashboard({DateTime? start, DateTime? end}) async {
    if (start != null) _startDate = start;
    if (end != null)   _endDate   = end;

    _status = SalesDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getDashboardData.execute(
      startDate: '${_startDate.year}-${_startDate.month.toString().padLeft(2,'0')}-${_startDate.day.toString().padLeft(2,'0')}',
      endDate:   '${_endDate.year}-${_endDate.month.toString().padLeft(2,'0')}-${_endDate.day.toString().padLeft(2,'0')}',
    );

    if (result['success'] == true) {
      _dashboardData = result['data'] as SalesDashboardResponse;
      _status        = SalesDashboardStatus.loaded;
    } else {
      _status       = SalesDashboardStatus.error;
      _errorMessage = result['message'] ?? 'Failed to load dashboard';
    }
    notifyListeners();
  }

  Future<void> refresh() => loadDashboard();
}