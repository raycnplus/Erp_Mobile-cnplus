import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/models/balance_sheet_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/datasources/balance_sheet_remote_datasource.dart' show ExportUrlInfo;
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/domain/usecases/balance_sheet_usecases.dart';

const List<String> kBalanceSheetFilterTypes = ['today', 'end_of_month', 'end_of_quarter', 'end_of_year', 'custom'];

class BalanceSheetController extends ChangeNotifier {
  final GetBalanceSheetReport getReport;
  final GetBalanceSheetExportPdfUrl getExportPdfUrl;
  final GetBalanceSheetExportExcelUrl getExportExcelUrl;

  BalanceSheetController({
    required this.getReport,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  BalanceSheetResult? _result;
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

  BalanceSheetResult? get result => _result;
  List<BalanceSheetRow> get tableRows => _result?.rows ?? [];
  List<BalanceSheetDateLabel> get columnDates => _result?.dates ?? [];
  bool get isLoadingReport => _isLoadingReport;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get reportError => _reportError;

  String get filterType => _filterType;
  DateTime? get customDate => _customDate;
  int? get month => _month;
  int? get monthYear => _monthYear;
  String get quarter => _quarter;
  int? get year => _year;

  double get totalAssets => _result?.totalAssetsRow?.amounts.isNotEmpty == true
      ? _result!.totalAssetsRow!.amounts.last
      : 0;
  double get totalLiabilitiesAndEquity => _result?.totalLiabilitiesAndEquityRow?.amounts.isNotEmpty == true
      ? _result!.totalLiabilitiesAndEquityRow!.amounts.last
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

  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.storage.request();
    return status.isGranted || status.isLimited;
  }

  Future<void> startExport(String exportType) async {
    if (!canExport || _isExporting) return;

    final hasPermission = await _ensureStoragePermission();
    if (!hasPermission) {
      _statusMessage = 'Storage permission is required to download the file.';
      notifyListeners();
      return;
    }

    final ExportUrlInfo info = exportType == 'pdf'
        ? getExportPdfUrl(dates: _appliedDates!, filterType: _filterType)
        : getExportExcelUrl(dates: _appliedDates!, filterType: _filterType);

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    try {
      final ext = exportType == 'pdf' ? 'pdf' : 'xlsx';
      final fileName = 'balance_sheet_report_${DateTime.now().millisecondsSinceEpoch}.$ext';

      final taskId = await FlutterDownloader.enqueue(
        url: info.url,
        headers: info.headers,
        savedDir: '/storage/emulated/0/Download',
        fileName: fileName,
        saveInPublicStorage: true,
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId == null) {
        _isExporting = false;
        notifyListeners();
        return;
      }

      _currentTaskId = taskId;
      DownloadService.instance.listen(taskId, (status, progress) {
        _downloadProgress = progress;

        if (status == DownloadTaskStatus.complete) {
          _isExporting = false;
          _statusMessage = '${exportType.toUpperCase()} downloaded successfully to the Download folder: $fileName';
          DownloadService.instance.unlisten(taskId);
          _currentTaskId = null;
        } else if (status == DownloadTaskStatus.failed) {
          _isExporting = false;
          _statusMessage = '${exportType.toUpperCase()} download failed.';
          DownloadService.instance.unlisten(taskId);
          _currentTaskId = null;
        } else if (status == DownloadTaskStatus.canceled) {
          _isExporting = false;
          DownloadService.instance.unlisten(taskId);
          _currentTaskId = null;
        }
        notifyListeners();
      });
    } catch (e) {
      _isExporting = false;
      _statusMessage = _msg(e);
      notifyListeners();
    }
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