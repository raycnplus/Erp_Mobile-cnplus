import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/data/models/general_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/domain/usecases/general_dashboard_usecases.dart';

enum GeneralDashboardState {
  initial,
  loading,
  loaded,
  error,
}

class GeneralDashboardController extends ChangeNotifier {
  final GetGeneralDashboard getGeneralDashboard;

  GeneralDashboardController({
    required this.getGeneralDashboard,
  });

  GeneralDashboardState _state =
      GeneralDashboardState.initial;
  GeneralDashboardModel? _data;
  String? _error;

  DateTime _startDate = DateTime(
    DateTime.now().year,
    1,
    1,
  );

  DateTime _endDate = DateTime.now();

  GeneralDashboardState get state => _state;

  GeneralDashboardModel? get data => _data;

  String? get error => _error;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> load({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (startDate != null) {
      _startDate = startDate;
    }

    if (endDate != null) {
      _endDate = endDate;
    }

    _state = GeneralDashboardState.loading;
    _error = null;

    notifyListeners();

    try {
      _data = await getGeneralDashboard(
        startDate: _fmt(_startDate),
        endDate: _fmt(_endDate),
      );

      _state = GeneralDashboardState.loaded;
    } catch (e) {
      _state = GeneralDashboardState.error;

      _error = e
          .toString()
          .replaceFirst('Exception:', '')
          .trim();
    }

    notifyListeners();
  }
}