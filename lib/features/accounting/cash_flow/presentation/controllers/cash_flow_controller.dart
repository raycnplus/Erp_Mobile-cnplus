import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/models/cash_flow_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/datasources/cash_flow_remote_datasource.dart' show ExportUrlInfo;
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/domain/usecases/cash_flow_usecases.dart';

const List<String> kCashFlowFilterTypes = ['today', 'end_of_month', 'end_of_quarter', 'end_of_year', 'custom'];

class CashFlowController extends ChangeNotifier {
  final GetCashFlowReport getReport;
  final GetCashFlowExportPdfUrl getExportPdfUrl;
  final GetCashFlowExportExcelUrl getExportExcelUrl;

  CashFlowController({
    required this.getReport,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  CashFlowResult? _result;
  bool _isLoadingReport = false;
  bool _hasFetchedOnce = false;
  String? _reportError;

  String _filterType = 'today';
  DateTime? _customDate;
  int? _month;
  int? _monthYear;
  String _quarter = 'Q1';
  int? _year;

  List<String>? _appliedDates;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  CashFlowResult? get result => _result;
  List<CashFlowRow> get tableRows => _result?.rows ?? [];
  List<CashFlowDateLabel> get columnDates => _result?.dates ?? [];
  bool get isLoadingReport => _isLoadingReport;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get reportError => _reportError;

  String get filterType => _filterType;
  DateTime? get customDate => _customDate;
  int? get month => _month;
  int? get monthYear => _monthYear;
  String get quarter => _quarter;
  int? get year => _year;

  double get closingBalance => _result?.closingBalanceRow?.amounts.isNotEmpty == true
      ? _result!.closingBalanceRow!.amounts.last
      : 0;

  bool get canExport => tableRows.isNotEmpty && _appliedDates != null && _appliedDates!.isNotEmpty;
  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

  void setFilterType(String type) => _filterType = type;
  void setCustomDate(DateTime date) => _customDate = date;
  void setMonth(int month, int year) {
    _month = month;
    _monthYear = year;
  }
  void setQuarter(String q) => _quarter = q;
  void setYear(int y) => _year = y;

  String _fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<String>? _calculateDates() {
    switch (_filterType) {
      case 'today':
        return [_fmt(DateTime.now())];

      case 'end_of_month':
        if (_month == null || _monthYear == null) {
          _reportError = 'Please select a month!';
          return null;
        }
        final endOfMonth = DateTime(_monthYear!, _month! + 1, 0);
        return [_fmt(endOfMonth)];

      case 'end_of_quarter':
        if (_year == null) {
          _reportError = 'Please select a year!';
          return null;
        }
        
        const quarterStartMonths = {'Q1': 1, 'Q2': 4, 'Q3': 7, 'Q4': 10};
        final startMonth = quarterStartMonths[_quarter]!;
        final dates = <String>[];
        for (var i = 0; i < 3; i++) {
          final endOfMonth = DateTime(_year!, startMonth + i + 1, 0);
          dates.add(_fmt(endOfMonth));
        }
        return dates;

      case 'end_of_year':
        if (_year == null) {
          _reportError = 'Please select a year!';
          return null;
        }
        return [_fmt(DateTime(_year!, 12, 31))];

      case 'custom':
        if (_customDate == null) {
          _reportError = 'Please select a date!';
          return null;
        }
        return [_fmt(_customDate!)];

      default:
        return null;
    }
  }

  void resetFilter() {
    _filterType = 'today';
    _customDate = null;
    _month = null;
    _monthYear = null;
    _quarter = 'Q1';
    _year = null;
    _appliedDates = null;
    _result = null;
    _hasFetchedOnce = false;
    notifyListeners();
  }

  Future<void> applyFilter() async {
    _reportError = null;
    final dates = _calculateDates();
    if (dates == null) {
      notifyListeners();
      return;
    }

    _appliedDates = dates;
    _isLoadingReport = true;
    _hasFetchedOnce = true;
    notifyListeners();
    try {
      _result = await getReport(dates: dates);
    } catch (e) {
      _reportError = _msg(e);
      _result = null;
    } finally {
      _isLoadingReport = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => applyFilter();

  Future<void> startExport(String exportType) async {
    if (!canExport || _isExporting) return;

    final ExportUrlInfo info = exportType == 'pdf'
        ? getExportPdfUrl(dates: _appliedDates!, filterType: _filterType)
        : getExportExcelUrl(dates: _appliedDates!, filterType: _filterType);

    final ext = exportType == 'pdf' ? 'pdf' : 'xlsx';

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    _currentTaskId = await DownloadService.instance.download(
      url: info.url,
      headers: info.headers,
      fileName: 'cash_flow_report_${DateTime.now().millisecondsSinceEpoch}.$ext',
      label: 'Cash Flow ${exportType.toUpperCase()}',
      onProgress: (p) {
        _downloadProgress = p;
        notifyListeners();
      },
      onMessage: (m) {
        _statusMessage = m;
        notifyListeners();
      },
      onFinished: () {
        _isExporting = false;
        _currentTaskId = null;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    if (_currentTaskId != null) {
      DownloadService.instance.unlisten(_currentTaskId!);
    }
    super.dispose();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}
