import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/domain/usecases/store_session_report_usecases.dart';

class StoreSessionReportController extends ChangeNotifier {
  final GetStoreSessionList getList;
  final GetStoreSessionFormOptions getFormOptions;
  final GetStoreSessionDetail getDetail;
  final GetStoreSessionTransactions getTransactions;
  final GetStoreSessionCashMovements getCashMovements;
  final GetSessionTransactionDetail getTransactionDetail;
  final GetStoreSessionExportUrl getExportSessionUrl;
  final GetSessionTransactionExportUrl getExportTransactionUrl;

  StoreSessionReportController({
    required this.getList,
    required this.getFormOptions,
    required this.getDetail,
    required this.getTransactions,
    required this.getCashMovements,
    required this.getTransactionDetail,
    required this.getExportSessionUrl,
    required this.getExportTransactionUrl,
  });

  static const int _perPage = 15;

  List<StoreSessionItem> _all = [];
  List<StoreSessionItem> _filtered = [];
  bool _isLoadingList = false;
  bool _hasFetchedOnce = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  int? _idStore;
  String? _status;

  StoreSessionFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  String? _sessionEnc;
  StoreSessionDetail? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  List<StoreSessionTransaction> _transactions = [];
  bool _isLoadingTx = false;
  String? _txError;
  int _txPage = 1;
  int _txLastPage = 1;
  int _txTotal = 0;
  double _txTotalAmountAll = 0;
  DateTime? _txDateFrom;
  DateTime? _txDateTo;
  String? _txPayment;
  String _txSearch = '';
  int _txReq = 0;

  List<StoreSessionCashMovement> _cashMovements = [];
  bool _isLoadingCm = false;
  String? _cmError;
  int _cmPage = 1;
  int _cmLastPage = 1;
  int _cmTotal = 0;
  StoreSessionCashSummary? _cmSummary;

  StoreSessionTransactionDetail? _transactionDetail;
  bool _isLoadingTransactionDetail = false;
  String? _transactionDetailError;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  List<StoreSessionItem> get list {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  bool get isLoadingList => _isLoadingList;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  int? get selectedStoreId => _idStore;
  String? get selectedStatus => _status;
  bool get hasActiveFilter => _idStore != null || _status != null;

  bool get isLoadingOptions => _isLoadingOptions;
  List<SessionStoreOption> get storeOptions => _formOptions?.storeList ?? [];
  List<String> get statusOptions => _formOptions?.statusList ?? [];
  List<String> get paymentMethodOptions => _formOptions?.paymentMethodList ?? [];

  StoreSessionDetail? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  List<StoreSessionTransaction> get transactions => _transactions;
  bool get isLoadingTx => _isLoadingTx;
  String? get txError => _txError;
  int get txPage => _txPage;
  int get txLastPage => _txLastPage;
  int get txTotal => _txTotal;
  double get txTotalAmountAll => _txTotalAmountAll;
  DateTime? get txDateFrom => _txDateFrom;
  DateTime? get txDateTo => _txDateTo;
  String? get txPayment => _txPayment;
  bool get hasTxPrev => _txPage > 1;
  bool get hasTxNext => _txPage < _txLastPage;

  List<StoreSessionCashMovement> get cashMovements => _cashMovements;
  bool get isLoadingCm => _isLoadingCm;
  String? get cmError => _cmError;
  int get cmPage => _cmPage;
  int get cmLastPage => _cmLastPage;
  int get cmTotal => _cmTotal;
  StoreSessionCashSummary? get cmSummary => _cmSummary;
  bool get hasCmPrev => _cmPage > 1;
  bool get hasCmNext => _cmPage < _cmLastPage;

  StoreSessionTransactionDetail? get transactionDetail => _transactionDetail;
  bool get isLoadingTransactionDetail => _isLoadingTransactionDetail;
  String? get transactionDetailError => _transactionDetailError;

  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;
  bool get canExportSession => _detail != null && !_isExporting;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

  String? _fmt(DateTime? d) => d == null
      ? null
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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

  void selectStore(int? value) => _idStore = value;
  void selectStatus(String? value) => _status = (value == null || value.isEmpty) ? null : value;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _hasFetchedOnce = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <StoreSessionItem>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          idStore: _idStore?.toString(),
          status: _status,
        );
        final meta = r['meta'] as StoreSessionPaginationMeta;
        all.addAll(r['items'] as List<StoreSessionItem>);
        if (p >= meta.lastPage) break;
        p++;
      }

      _all = all;
      _applyLocalFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _msg(e);
      _all = [];
      _filtered = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyLocalFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_all);
      return;
    }
    final q = _searchQuery.toLowerCase();
    _filtered = _all.where((s) {
      return s.idSessionLabel.toLowerCase().contains(q) ||
          s.storeName.toLowerCase().contains(q) ||
          s.openedBy.toLowerCase().contains(q) ||
          s.status.toLowerCase().contains(q);
    }).toList();
  }

  void searchList(String q) {
    _searchQuery = q.trim();
    _currentPage = 1;
    if (!_hasFetchedOnce) {
      fetchList();
      return;
    }
    _applyLocalFilter();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    _applyLocalFilter();
    notifyListeners();
  }

  void goToPage(int p) {
    if (p < 1 || p > lastPage) return;
    _currentPage = p;
    notifyListeners();
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<void> applyFilter() => fetchList();

  void resetFilter() {
    _idStore = null;
    _status = null;
    if (_searchQuery.isNotEmpty) {
      fetchList();
      return;
    }
    _all = [];
    _filtered = [];
    _currentPage = 1;
    _hasFetchedOnce = false;
    _listError = null;
    notifyListeners();
  }

  void prepareSession(String enc) {
    _sessionEnc = enc;
    _detail = null;
    _detailError = null;
    _isLoadingDetail = true;

    _transactions = [];
    _txError = null;
    _txPage = 1;
    _txLastPage = 1;
    _txTotal = 0;
    _txTotalAmountAll = 0;
    _txDateFrom = null;
    _txDateTo = null;
    _txPayment = null;
    _txSearch = '';
    _isLoadingTx = true;

    _cashMovements = [];
    _cmError = null;
    _cmPage = 1;
    _cmLastPage = 1;
    _cmTotal = 0;
    _cmSummary = null;
    _isLoadingCm = true;
  }

  Future<void> loadSession() => Future.wait([
        fetchSessionDetail(),
        fetchTransactions(),
        fetchCashMovements(),
      ]);

  Future<void> fetchSessionDetail() async {
    final enc = _sessionEnc;
    if (enc == null) return;
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _detail = await getDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> fetchTransactions({int page = 1}) async {
    final enc = _sessionEnc;
    if (enc == null) return;

    final req = ++_txReq;
    _isLoadingTx = true;
    _txError = null;
    notifyListeners();

    try {
      final r = await getTransactions(
        enc,
        page: page,
        perPage: _perPage,
        dateFrom: _fmt(_txDateFrom),
        dateTo: _fmt(_txDateTo),
        paymentMethod: _txPayment,
        search: _txSearch.isEmpty ? null : _txSearch,
      );
      if (req != _txReq) return;

      final meta = r['meta'] as StoreSessionPaginationMeta;
      _transactions = r['items'] as List<StoreSessionTransaction>;
      _txPage = meta.currentPage;
      _txLastPage = meta.lastPage;
      _txTotal = meta.total;
      _txTotalAmountAll = r['totalAmountAll'] as double;
    } catch (e) {
      if (req != _txReq) return;
      _txError = _msg(e);
      _transactions = [];
    } finally {
      if (req == _txReq) {
        _isLoadingTx = false;
        notifyListeners();
      }
    }
  }

  Future<void> goToTxPage(int p) async {
    if (p < 1 || p > _txLastPage) return;
    await fetchTransactions(page: p);
  }

  Future<void> nextTxPage() => goToTxPage(_txPage + 1);
  Future<void> prevTxPage() => goToTxPage(_txPage - 1);

  Future<void> setTxSearch(String q) {
    _txSearch = q.trim();
    return fetchTransactions();
  }

  Future<void> setTxPayment(String? method) {
    _txPayment = (method == null || method.isEmpty) ? null : method;
    return fetchTransactions();
  }

  Future<void> setTxDateRange(DateTime? from, DateTime? to) {
    _txDateFrom = from;
    _txDateTo = to;
    return fetchTransactions();
  }

  Future<void> fetchCashMovements({int page = 1}) async {
    final enc = _sessionEnc;
    if (enc == null) return;

    _isLoadingCm = true;
    _cmError = null;
    notifyListeners();

    try {
      final r = await getCashMovements(enc, page: page, perPage: _perPage);
      final meta = r['meta'] as StoreSessionPaginationMeta;
      _cashMovements = r['items'] as List<StoreSessionCashMovement>;
      _cmPage = meta.currentPage;
      _cmLastPage = meta.lastPage;
      _cmTotal = meta.total;
      _cmSummary = r['summary'] as StoreSessionCashSummary;
    } catch (e) {
      _cmError = _msg(e);
      _cashMovements = [];
    } finally {
      _isLoadingCm = false;
      notifyListeners();
    }
  }

  Future<void> goToCmPage(int p) async {
    if (p < 1 || p > _cmLastPage) return;
    await fetchCashMovements(page: p);
  }

  Future<void> nextCmPage() => goToCmPage(_cmPage + 1);
  Future<void> prevCmPage() => goToCmPage(_cmPage - 1);

  void prepareTransactionDetail() {
    _transactionDetail = null;
    _transactionDetailError = null;
    _isLoadingTransactionDetail = true;
  }

  Future<void> fetchTransactionDetail(String enc) async {
    _isLoadingTransactionDetail = true;
    _transactionDetailError = null;
    notifyListeners();
    try {
      _transactionDetail = await getTransactionDetail(enc);
    } catch (e) {
      _transactionDetailError = _msg(e);
      _transactionDetail = null;
    } finally {
      _isLoadingTransactionDetail = false;
      notifyListeners();
    }
  }

  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.storage.request();
    return status.isGranted || status.isLimited;
  }

  Future<void> exportSession() async {
    final enc = _sessionEnc;
    if (enc == null) return;
    await _startDownload(
      getExportSessionUrl(
        enc,
        dateFrom: _fmt(_txDateFrom),
        dateTo: _fmt(_txDateTo),
        paymentMethod: _txPayment,
      ),
      'store_session',
    );
  }

  Future<void> exportTransactionDetail(String enc) =>
      _startDownload(getExportTransactionUrl(enc), 'pos_transaction');

  Future<void> _startDownload(SessionExportUrlInfo info, String prefix) async {
    if (_isExporting) return;

    final hasPermission = await _ensureStoragePermission();
    if (!hasPermission) {
      _statusMessage = 'Storage permission is required to download the file.';
      notifyListeners();
      return;
    }

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    try {
      final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.xlsx';

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