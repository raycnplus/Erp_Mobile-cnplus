import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/dashboard/data/models/hr_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/domain/usecases/hr_dashboard_usecases.dart';

enum HrDashboardStatus {
  initial,
  loading,
  loaded,
  error,
}

enum HrDashboardViewMode {
  admin,
  staff,
}

class HrDashboardController extends ChangeNotifier {
  final GetHrDashboardData getHrDashboardData;
  final GetHrStaffDashboardData getHrStaffDashboardData;

  HrDashboardController({
    required this.getHrDashboardData,
    required this.getHrStaffDashboardData,
  });

  // ============================================================
  // STATE
  // ============================================================

  HrDashboardStatus _status =
      HrDashboardStatus.initial;

  String? _errorMessage;

  HrDashboardData? _dashboardData;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  // Role asli user.
  // Jangan berubah ketika pindah ke Staff View.
  bool _userIsAdmin = false;

  // Mode tampilan sekarang.
  HrDashboardViewMode _viewMode =
      HrDashboardViewMode.admin;

  // ============================================================
  // GETTERS
  // ============================================================

  HrDashboardStatus get status => _status;

  String? get errorMessage => _errorMessage;

  HrDashboardData? get dashboardData =>
      _dashboardData;

  bool get isLoading =>
      _status == HrDashboardStatus.loading;

  bool get hasData =>
      _dashboardData != null;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  /// Role asli user.
  bool get userIsAdmin =>
      _userIsAdmin;

  /// Mode tampilan saat ini.
  HrDashboardViewMode get viewMode =>
      _viewMode;

  bool get isAdminView =>
      _viewMode ==
      HrDashboardViewMode.admin;

  bool get isStaffView =>
      _viewMode ==
      HrDashboardViewMode.staff;

  // ============================================================
  // INITIAL LOAD / ADMIN DASHBOARD
  // ============================================================

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

    _status =
        HrDashboardStatus.loading;

    _errorMessage = null;

    notifyListeners();

    try {
      final data =
          await getHrDashboardData(
        startDate: _fmt(_startDate),
        endDate: _fmt(_endDate),
      );

      _dashboardData = data;

      // Simpan role asli user hanya dari
      // response dashboard utama.
      //
      // Jangan ambil lagi dari _dashboardData
      // setelah switch ke staff.
      _userIsAdmin = data.isAdmin;

      // Initial view mengikuti role.
      if (_userIsAdmin) {
        _viewMode =
            HrDashboardViewMode.admin;
      } else {
        _viewMode =
            HrDashboardViewMode.staff;
      }

      _status =
          HrDashboardStatus.loaded;
    } catch (e) {
      _status =
          HrDashboardStatus.error;

      _errorMessage = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      notifyListeners();
    }
  }

  // ============================================================
  // SWITCH TO STAFF
  // ============================================================

  Future<void> switchToStaffView() async {
    // Hanya user dengan role admin
    // yang boleh switch.
    if (!_userIsAdmin) {
      return;
    }

    _status =
        HrDashboardStatus.loading;

    _errorMessage = null;

    notifyListeners();

    try {
      final data =
          await getHrStaffDashboardData();

      _dashboardData = data;

      _viewMode =
          HrDashboardViewMode.staff;

      _status =
          HrDashboardStatus.loaded;
    } catch (e) {
      _status =
          HrDashboardStatus.error;

      _errorMessage = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      notifyListeners();
    }
  }

  // ============================================================
  // SWITCH TO ADMIN
  // ============================================================

  Future<void> switchToAdminView() async {
    if (!_userIsAdmin) {
      return;
    }

    await loadDashboard(
      start: _startDate,
      end: _endDate,
    );

    // loadDashboard sudah akan set admin,
    // ini hanya memastikan mode.
    _viewMode =
        HrDashboardViewMode.admin;

    notifyListeners();
  }

  // ============================================================
  // TOGGLE
  // ============================================================

  Future<void> toggleViewMode() async {
    if (!_userIsAdmin) {
      return;
    }

    if (_viewMode ==
        HrDashboardViewMode.admin) {
      await switchToStaffView();
    } else {
      await switchToAdminView();
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() async {
    if (_userIsAdmin &&
        _viewMode ==
            HrDashboardViewMode.staff) {
      await switchToStaffView();
      return;
    }

    await loadDashboard();
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _fmt(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}