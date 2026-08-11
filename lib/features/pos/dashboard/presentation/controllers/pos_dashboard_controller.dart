import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/models/pos_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/domain/usecases/pos_dashboard_usecases.dart';

enum PosDashboardStatus { initial, loading, loaded, error }

class PosDashboardController extends ChangeNotifier {
  final GetPosDashboard _getDashboard;

  PosDashboardController({required GetPosDashboard getPosDashboard})
      : _getDashboard = getPosDashboard;

  PosDashboardStatus _status = PosDashboardStatus.initial;
  String? _errorMessage;
  PosDashboardResponse? _data;

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  PosDashboardStatus get status => _status;
  String? get errorMessage => _errorMessage;
  PosDashboardResponse? get data => _data;
  bool get hasData => _data != null;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> loadDashboard({DateTime? start, DateTime? end}) async {
    if (start != null) _startDate = start;
    if (end != null) _endDate = end;
    _status = PosDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _data = await _getDashboard(
        startDate: _fmt(_startDate),
        endDate: _fmt(_endDate),
      );
      _status = PosDashboardStatus.loaded;
    } catch (e) {
      _status = PosDashboardStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  void updateDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    loadDashboard(start: start, end: end);
  }

  Future<void> refresh() => loadDashboard();
}