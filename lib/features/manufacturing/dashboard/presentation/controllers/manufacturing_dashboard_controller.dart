import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/models/manufacturing_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/domain/usecases/manufacturing_dashboard_usecases.dart';

enum ManufacturingDashboardStatus { initial, loading, loaded, error }

class ManufacturingDashboardController extends ChangeNotifier {
  final GetManufacturingDashboardData _getDashboardData;

  ManufacturingDashboardController({
    required GetManufacturingDashboardData getManufacturingDashboardData,
  }) : _getDashboardData = getManufacturingDashboardData;

  ManufacturingDashboardStatus _status = ManufacturingDashboardStatus.initial;
  String? _errorMessage;
  ManufacturingDashboardResponse? _dashboardData;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  ManufacturingDashboardStatus get status => _status;
  String? get errorMessage => _errorMessage;
  ManufacturingDashboardResponse? get dashboardData => _dashboardData;
  bool get isLoading => _status == ManufacturingDashboardStatus.loading;
  bool get hasData => _dashboardData != null;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> loadDashboard({DateTime? start, DateTime? end}) async {
    if (start != null) _startDate = start;
    if (end != null) _endDate = end;

    _status = ManufacturingDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getDashboardData.execute(
      startDate: _fmt(_startDate),
      endDate: _fmt(_endDate),
    );

    if (result['success'] == true) {
      _dashboardData = result['data'] as ManufacturingDashboardResponse;
      _status = ManufacturingDashboardStatus.loaded;
    } else {
      _status = ManufacturingDashboardStatus.error;
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