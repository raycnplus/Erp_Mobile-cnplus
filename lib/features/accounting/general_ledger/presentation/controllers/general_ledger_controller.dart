import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/models/general_ledger_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/datasources/general_ledger_remote_datasource.dart' show ExportUrlInfo;
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/domain/usecases/general_ledger_usecases.dart';

class GeneralLedgerController extends ChangeNotifier {
  final GetGeneralLedgerReport getReport;
  final GetGeneralLedgerFormOptions getFormOptions;
  final GetGeneralLedgerExportPdfUrl getExportPdfUrl;
  final GetGeneralLedgerExportExcelUrl getExportExcelUrl;

  GeneralLedgerController({
    required this.getReport,
    required this.getFormOptions,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  GeneralLedgerReportResult? _result;
  bool _isLoadingReport = false;
  bool _hasFetchedOnce = false;
  String? _reportError;

  GeneralLedgerFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _coaFrom = 'All';
  String _coaTo = 'All';

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  GeneralLedgerReportResult? get result => _result;
  List<GeneralLedgerRow> get tableRows => _result?.toRows() ?? [];
  bool get isLoadingReport => _isLoadingReport;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get reportError => _reportError;

  GeneralLedgerFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String get coaFrom => _coaFrom;
  String get coaTo => _coaTo;

  double get grandTotalDebit => _result?.grandTotalDebit ?? 0;
  double get grandTotalCredit => _result?.grandTotalCredit ?? 0;

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

  void selectCoaFrom(String? value) => _coaFrom = (value == null || value.isEmpty) ? 'All' : value;
  void selectCoaTo(String? value) => _coaTo = (value == null || value.isEmpty) ? 'All' : value;

  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;
  }

  String? validateFilter() {
    if (_dateFrom == null) return 'From Date is required!';
    if (_dateTo == null) return 'To Date is required!';
    if (_dateFrom!.isAfter(_dateTo!)) return 'From Date cannot be later than To Date!';
    if (_coaFrom != 'All' && _coaTo != 'All' && _coaFrom.compareTo(_coaTo) > 0) {
      return 'COA From cannot be greater than COA To!';
    }
    return null;
  }

  void resetFilter() {
    _coaFrom = 'All';
    _coaTo = 'All';
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
    _isLoadingReport = true;
    _reportError = null;
    _hasFetchedOnce = true;
    notifyListeners();
    try {
      _result = await getReport(
        dateFrom: _fmt(_dateFrom),
        dateTo: _fmt(_dateTo),
        coaFrom: _coaFrom,
        coaTo: _coaTo,
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

  Future<void> startExport(String type) async {
    if (!canExport || _isExporting) return;

    final ExportUrlInfo info = type == 'pdf'
        ? getExportPdfUrl(dateFrom: _fmt(_dateFrom), dateTo: _fmt(_dateTo), coaFrom: _coaFrom, coaTo: _coaTo)
        : getExportExcelUrl(dateFrom: _fmt(_dateFrom), dateTo: _fmt(_dateTo), coaFrom: _coaFrom, coaTo: _coaTo);

    final ext = type == 'pdf' ? 'pdf' : 'xlsx';

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    _currentTaskId = await DownloadService.instance.download(
      url: info.url,
      headers: info.headers,
      fileName: 'general_ledger_${DateTime.now().millisecondsSinceEpoch}.$ext',
      label: 'General Ledger ${type.toUpperCase()}',
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