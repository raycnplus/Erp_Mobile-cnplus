import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/models/crm_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/domain/usecases/crm_dashboard_usecases.dart';

enum CrmDashboardStatus { initial, loading, loaded, error }

class CrmDashboardController extends ChangeNotifier {
  final GetCrmDashboard _getDashboard;
  final GetCrmConversationChart _getConvChart;
  final GetCrmMessageChart _getMsgChart;

  CrmDashboardController({
    required GetCrmDashboard getDashboard,
    required GetCrmConversationChart getConversationChart,
    required GetCrmMessageChart getMessageChart,
  })  : _getDashboard = getDashboard,
        _getConvChart = getConversationChart,
        _getMsgChart = getMessageChart;

  CrmDashboardStatus _status = CrmDashboardStatus.initial;
  String? _errorMessage;
  CrmDashboardResponse? _data;

  CrmGranularity _convGranularity = CrmGranularity.year;
  CrmGranularity _msgGranularity = CrmGranularity.year;
  CrmChartData? _convChart;
  CrmChartData? _msgChart;
  bool _convChartLoading = false;
  bool _msgChartLoading = false;

  CrmDashboardStatus get status => _status;
  String? get errorMessage => _errorMessage;
  CrmDashboardResponse? get data => _data;
  bool get hasData => _data != null;

  CrmGranularity get convGranularity => _convGranularity;
  CrmGranularity get msgGranularity => _msgGranularity;
  CrmChartData? get convChart => _convChart;
  CrmChartData? get msgChart => _msgChart;
  bool get convChartLoading => _convChartLoading;
  bool get msgChartLoading => _msgChartLoading;

  Future<void> loadDashboard() async {
    _status = CrmDashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _data = await _getDashboard(granularity: _convGranularity.value);
      _convChart = _data!.conversationChart;
      _msgChart = _data!.messageChart;
      _status = CrmDashboardStatus.loaded;
    } catch (e) {
      _status = CrmDashboardStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  Future<void> changeConvGranularity(CrmGranularity g) async {
    if (_convGranularity == g) return;
    _convGranularity = g;
    _convChartLoading = true;
    notifyListeners();

    try {
      _convChart = await _getConvChart(granularity: g.value);
    } catch (_) {}

    _convChartLoading = false;
    notifyListeners();
  }

  Future<void> changeMsgGranularity(CrmGranularity g) async {
    if (_msgGranularity == g) return;
    _msgGranularity = g;
    _msgChartLoading = true;
    notifyListeners();

    try {
      _msgChart = await _getMsgChart(granularity: g.value);
    } catch (_) {}

    _msgChartLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadDashboard();
}