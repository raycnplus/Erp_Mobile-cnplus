import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/models/ar_aging_report_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/datasources/ar_aging_report_remote_datasource.dart' show ExportUrlInfo;
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/domain/usecases/ar_aging_report_usecases.dart';

const String kARAgingAllCustomer = 'All';

class ARAgingReportController extends ChangeNotifier {
  final GetARAgingReport getReport;
  final GetARAgingFormOptions getFormOptions;
  final GetARAgingExportPdfUrl getExportPdfUrl;
  final GetARAgingExportExcelUrl getExportExcelUrl;

  ARAgingReportController({
    required this.getReport,
    required this.getFormOptions,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  ARAgingResult? _result;
  bool _isLoadingReport = false;
  bool _hasFetchedOnce = false;
  String? _reportError;

  ARAgingFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  String _customerId = kARAgingAllCustomer;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _viewType = 'receivable';

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  ARAgingResult? get result => _result;
  List<ARAgingRow> get tableRows => _result?.rows ?? [];
  ARAgingSummary? get summary => _result?.summary;
  ARAgingTotals? get totals => _result?.totals;
  bool get isLoadingReport => _isLoadingReport;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get reportError => _reportError;

  ARAgingFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  String get customerId => _customerId;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String get viewType => _viewType;

  bool get canExport => tableRows.isNotEmpty;
  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_optionsLoaded && !forceRefresh) return;
    _isLoadingOptions = true;
    notifyListeners();
    try {
      _formOptions = await getFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  void selectCustomer(String? value) => _customerId = (value == null || value.isEmpty) ? kARAgingAllCustomer : value;
  void selectViewType(String? value) => _viewType = (value == null || value.isEmpty) ? 'receivable' : value;

  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;
  }

  String? validateFilter() {
    if (_dateFrom != null && _dateTo != null && _dateFrom!.isAfter(_dateTo!)) {
      return 'From Date cannot be later than To Date!';
    }
    return null;
  }

  void resetFilter() {
    _customerId = kARAgingAllCustomer;
    _dateFrom = null;
    _dateTo = null;
    _viewType = 'receivable';
    applyFilter();
  }

  String? _fmt(DateTime? d) => d == null
      ? null
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> applyFilter() async {
    final error = validateFilter();
    if (error != null) {
      _reportError = error;
      notifyListeners();
      return;
    }

    _isLoadingReport = true;
    _reportError = null;
    _hasFetchedOnce = true;
    notifyListeners();
    try {
      _result = await getReport(
        customerId: _customerId == kARAgingAllCustomer ? null : int.tryParse(_customerId),
        dateFrom: _fmt(_dateFrom),
        dateTo: _fmt(_dateTo),
        viewType: _viewType,
      );
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

    final customerIdParam = _customerId == kARAgingAllCustomer ? null : int.tryParse(_customerId);

    final ExportUrlInfo info = exportType == 'pdf'
        ? getExportPdfUrl(customerId: customerIdParam, dateFrom: _fmt(_dateFrom), dateTo: _fmt(_dateTo), viewType: _viewType)
        : getExportExcelUrl(customerId: customerIdParam, dateFrom: _fmt(_dateFrom), dateTo: _fmt(_dateTo), viewType: _viewType);

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    try {
      final ext = exportType == 'pdf' ? 'pdf' : 'xlsx';
      final fileName = 'ar_aging_report_${DateTime.now().millisecondsSinceEpoch}.$ext';

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