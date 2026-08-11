import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/models/hr_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/domain/usecases/hr_dashboard_usecases.dart.dart';

enum HrDashboardStatus { initial, loading, loaded, error }

class HrDashboardController extends ChangeNotifier {
  final GetHrDashboardData getHrDashboardData;

  HrDashboardController({required this.getHrDashboardData});

  HrDashboardStatus _status = HrDashboardStatus.initial;
  String? _errorMessage;
  HrDashboardData? _dashboardData;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  HrDashboardStatus get status => _status;
  String? get errorMessage => _errorMessage;
  HrDashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _status == HrDashboardStatus.loading;
  bool get hasData => _dashboardData != null;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  Future<void> loadDashboard({DateTime? start, DateTime? end}) async {
    if (start != null) _startDate = start;
    if (end != null) _endDate = end;

    _status = HrDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardData = await getHrDashboardData(
        startDate: _fmt(_startDate),
        endDate: _fmt(_endDate),
      );
      _status = HrDashboardStatus.loaded;
    } catch (e) {
      _status = HrDashboardStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  Future<void> refresh() => loadDashboard();

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}