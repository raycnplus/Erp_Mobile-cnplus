import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/models/trial_balance_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/datasources/trial_balance_remote_datasource.dart' show ExportUrlInfo;
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/domain/usecases/trial_balance_usecases.dart';

class TrialBalanceController extends ChangeNotifier {
  final GetTrialBalanceReport getReport;
  final GetTrialBalanceExportPdfUrl getExportPdfUrl;
  final GetTrialBalanceExportExcelUrl getExportExcelUrl;

  TrialBalanceController({
    required this.getReport,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  TrialBalanceResult? _result;
  bool _isLoadingReport = false;
  bool _hasFetchedOnce = false;
  String? _reportError;

  DateTime? _dateFrom;
  DateTime? _dateTo;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  TrialBalanceResult? get result => _result;
  List<TrialBalanceRow> get tableRows => _result?.rows ?? [];
  bool get isLoadingReport => _isLoadingReport;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get reportError => _reportError;

  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;

  double get totalSaldoAwalDebit => _result?.totalSaldoAwalDebit ?? 0;
  double get totalSaldoAwalKredit => _result?.totalSaldoAwalKredit ?? 0;
  double get totalMutasiDebit => _result?.totalMutasiDebit ?? 0;
  double get totalMutasiKredit => _result?.totalMutasiKredit ?? 0;
  double get totalSaldoAkhirDebit => _result?.totalSaldoAkhirDebit ?? 0;
  double get totalSaldoAkhirKredit => _result?.totalSaldoAkhirKredit ?? 0;

  bool get canExport => tableRows.isNotEmpty && _dateFrom != null && _dateTo != null;
  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

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
        dateFrom: _fmt(_dateFrom),
        dateTo: _fmt(_dateTo),
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

  Future<void> startExport(String exportType) async {
    if (!canExport || _isExporting) return;

    final ExportUrlInfo info = exportType == 'pdf'
        ? getExportPdfUrl(dateFrom: _fmt(_dateFrom), dateTo: _fmt(_dateTo))
        : getExportExcelUrl(dateFrom: _fmt(_dateFrom), dateTo: _fmt(_dateTo));

    final ext = exportType == 'pdf' ? 'pdf' : 'xlsx';

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    _currentTaskId = await DownloadService.instance.download(
      url: info.url,
      headers: info.headers,
      fileName: 'trial_balance_${DateTime.now().millisecondsSinceEpoch}.$ext',
      label: 'Trial Balance ${exportType.toUpperCase()}',
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