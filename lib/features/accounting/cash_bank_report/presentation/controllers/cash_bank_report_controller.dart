import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/models/cash_bank_report_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/datasources/cash_bank_report_remote_datasource.dart' show ExportUrlInfo;
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/domain/usecases/cash_bank_report_usecases.dart';

class CashBankReportController extends ChangeNotifier {
  final GetCashBankReport getReport;
  final GetCashBankReportFormOptions getFormOptions;
  final GetCashBankReportExportPdfUrl getExportPdfUrl;
  final GetCashBankReportExportExcelUrl getExportExcelUrl;

  CashBankReportController({
    required this.getReport,
    required this.getFormOptions,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  CashBankReportResult? _result;
  bool _isLoadingReport = false;
  bool _hasFetchedOnce = false;
  String? _reportError;

  CashBankReportFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _accountId = 'All';
  String _type = 'All';

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  CashBankReportResult? get result => _result;
  List<CashBankReportRow> get tableRows => _result?.toRows() ?? [];
  bool get isLoadingReport => _isLoadingReport;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get reportError => _reportError;

  CashBankReportFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String get accountId => _accountId;
  String get type => _type;

  double get grandTotalDebit => _result?.grandTotalDebit ?? 0;
  double get grandTotalCredit => _result?.grandTotalCredit ?? 0;
  double get endingBalance => _result?.endingBalance ?? 0;

  bool get canExport => tableRows.isNotEmpty && _dateFrom != null && _dateTo != null;
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

  void selectAccount(String? value) => _accountId = (value == null || value.isEmpty) ? 'All' : value;
  void selectType(String? value) => _type = (value == null || value.isEmpty) ? 'All' : value;

  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;
  }

  String? validateFilter() {
    if (_dateFrom == null) return 'From Date is required!';
    if (_dateTo == null) return 'To Date is required!';
    if (_dateFrom!.isAfter(_dateTo!)) return 'From Date cannot be later than To Date!';
    return null;
  }

  void resetFilter() {
    _accountId = 'All';
    _type = 'All';
    _dateFrom = null;
    _dateTo = null;
    _result = null;
    _hasFetchedOnce = false;
    notifyListeners();
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
        dateFrom: _fmt(_dateFrom)!,
        dateTo: _fmt(_dateTo)!,
        accountId: _accountId,
        type: _type,
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

  String? resolveAccountName(String? id) {
    if (id == null || id == 'All' || _formOptions == null) return null;
    final match = _formOptions!.accounts.where((a) => a.idCoa.toString() == id);
    return match.isNotEmpty ? match.first.display : null;
  }

  Future<void> startExport(String exportType) async {
    if (!canExport || _isExporting) return;

    final ExportUrlInfo info = exportType == 'pdf'
        ? getExportPdfUrl(dateFrom: _fmt(_dateFrom)!, dateTo: _fmt(_dateTo)!, accountId: _accountId, type: _type)
        : getExportExcelUrl(dateFrom: _fmt(_dateFrom)!, dateTo: _fmt(_dateTo)!, accountId: _accountId, type: _type);

    final ext = exportType == 'pdf' ? 'pdf' : 'xlsx';

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    _currentTaskId = await DownloadService.instance.download(
      url: info.url,
      headers: info.headers,
      fileName: 'cash_bank_report_${DateTime.now().millisecondsSinceEpoch}.$ext',
      label: 'Cash & Bank Report ${exportType.toUpperCase()}',
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