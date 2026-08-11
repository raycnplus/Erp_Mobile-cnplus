import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/models/inventory_dashboard_model.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/domain/usecases/inventory_dashboard_usecase.dart';

enum DashboardStatus {
  initial,
  loading,
  loaded,
  error,
}

class InventoryDashboardController extends ChangeNotifier {
  final GetInventoryDashboard _usecase;

  InventoryDashboardController(this._usecase);

  DashboardStatus _status = DashboardStatus.initial;
  String? _errorMessage;
  InventoryDashboardData? _data;

  DateTime _startDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  DateTime _endDate = DateTime.now();

  DashboardStatus get status => _status;

  String? get errorMessage => _errorMessage;

  InventoryDashboardData? get dashboardData => _data;

  bool get isLoading => _status == DashboardStatus.loading;

  bool get hasData => _data != null;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  String _fmt(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadDashboard({
    DateTime? start,
    DateTime? end,
  }) async {
    if (start != null) {
      _startDate = start;
    }

    if (end != null) {
      _endDate = end;
    }

    _status = DashboardStatus.loading;
    _errorMessage = null;

    notifyListeners();

    final result = await _usecase.execute(
      startDate: _fmt(_startDate),
      endDate: _fmt(_endDate),
    );

    if (result['success'] == true) {
      _data = result['data'] as InventoryDashboardData;
      _status = DashboardStatus.loaded;
    } else {
      _status = DashboardStatus.error;
      _errorMessage =
          result['message'] ?? 'Gagal memuat dashboard';
    }

    notifyListeners();
  }

  void updateDateRange(
    DateTime start,
    DateTime end,
  ) {
    _startDate = start;
    _endDate = end;

    loadDashboard(
      start: start,
      end: end,
    );
  }

  Future<void> refresh() {
    return loadDashboard();
  }
}