import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/models/billing_tax_report_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/datasources/billing_tax_report_remote_datasource.dart' show ExportUrlInfo;
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/domain/usecases/billing_tax_report_usecases.dart';

const String kBillingTaxAllCustomer = 'All';
const String kBillingTaxAllMonth = 'All';

class BillingTaxReportController extends ChangeNotifier {
  final GetBillingTaxReport getReport;
  final GetBillingTaxFormOptions getFormOptions;
  final GetBillingTaxExportExcelUrl getExportExcelUrl;

  BillingTaxReportController({
    required this.getReport,
    required this.getFormOptions,
    required this.getExportExcelUrl,
  });

  BillingTaxResult? _result;
  bool _isLoadingReport = false;
  bool _hasFetchedOnce = false;
  String? _reportError;

  BillingTaxFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  int _year = DateTime.now().year;
  String _month = kBillingTaxAllMonth;
  String _customerId = kBillingTaxAllCustomer;
  static const int _perPage = 15;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  BillingTaxResult? get result => _result;
  List<BillingTaxRow> get tableRows => _result?.page.rows ?? [];
  BillingTaxSummary? get summary => _result?.summary;
  bool get isLoadingReport => _isLoadingReport;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get reportError => _reportError;

  BillingTaxFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  int get year => _year;
  String get month => _month;
  String get customerId => _customerId;

  int get currentPage => _result?.page.currentPage ?? 1;
  int get lastPage => _result?.page.lastPage ?? 1;
  int get totalRecords => _result?.page.total ?? 0;
  bool get hasNextPage => _result?.page.hasNextPage ?? false;
  bool get hasPrevPage => _result?.page.hasPrevPage ?? false;

  bool get canExport => tableRows.isNotEmpty;
  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

  void setYear(int y) => _year = y;
  void setMonth(String? m) => _month = (m == null || m.isEmpty) ? kBillingTaxAllMonth : m;
  void selectCustomer(String? value) => _customerId = (value == null || value.isEmpty) ? kBillingTaxAllCustomer : value;

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

  String? validateFilter() {
    if (_year.toString().length != 4) return 'Masukkan tahun yang valid (4 digit).';
    return null;
  }

  void resetFilter() {
    _year = DateTime.now().year;
    _month = kBillingTaxAllMonth;
    _customerId = kBillingTaxAllCustomer;
    fetchPage(1);
  }

  int? get _monthParam => _month == kBillingTaxAllMonth ? null : int.tryParse(_month);
  int? get _customerParam => _customerId == kBillingTaxAllCustomer ? null : int.tryParse(_customerId);

  Future<void> applyFilter() async {
    final error = validateFilter();
    if (error != null) {
      _reportError = error;
      notifyListeners();
      return;
    }
    await fetchPage(1);
  }

  Future<void> fetchPage(int page) async {
    _isLoadingReport = true;
    _reportError = null;
    _hasFetchedOnce = true;
    notifyListeners();
    try {
      _result = await getReport(
        year: _year,
        month: _monthParam,
        customerId: _customerParam,
        page: page,
        perPage: _perPage,
      );
    } catch (e) {
      _reportError = _msg(e);
      _result = null;
    } finally {
      _isLoadingReport = false;
      notifyListeners();
    }
  }

  Future<void> nextPage() {
    if (!hasNextPage) return Future.value();
    return fetchPage(currentPage + 1);
  }

  Future<void> prevPage() {
    if (!hasPrevPage) return Future.value();
    return fetchPage(currentPage - 1);
  }

  Future<void> refresh() => fetchPage(currentPage);

  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.storage.request();
    return status.isGranted || status.isLimited;
  }

  Future<void> startExport() async {
    if (!canExport || _isExporting) return;

    final hasPermission = await _ensureStoragePermission();
    if (!hasPermission) {
      _statusMessage = 'Storage permission is required to download the file.';
      notifyListeners();
      return;
    }

    final info = getExportExcelUrl(year: _year, month: _monthParam, customerId: _customerParam);

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    try {
      final fileName = 'billing_tax_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';

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
          _statusMessage = 'Excel downloaded successfully to the Download folder: $fileName';
          DownloadService.instance.unlisten(taskId);
          _currentTaskId = null;
        } else if (status == DownloadTaskStatus.failed) {
          _isExporting = false;
          _statusMessage = 'Excel download failed.';
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