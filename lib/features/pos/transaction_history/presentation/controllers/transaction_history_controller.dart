import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/models/transaction_history_models.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/domain/usecases/transaction_history_usecases.dart';

class TransactionHistoryController extends ChangeNotifier {
  final GetTransactionHistoryList getList;
  final GetTransactionHistoryFormOptions getFormOptions;
  final GetTransactionHistoryDetail getDetail;
  final GetTransactionHistoryExportUrl getExportListUrl;
  final GetTransactionHistoryDetailExportUrl getExportDetailUrl;

  TransactionHistoryController({
    required this.getList,
    required this.getFormOptions,
    required this.getDetail,
    required this.getExportListUrl,
    required this.getExportDetailUrl,
  });

  static const int _perPage = 15;

  List<TransactionHistoryItem> _all = [];
  bool _isLoadingList = false;
  bool _hasFetchedOnce = false;
  String? _listError;
  int _currentPage = 1;
  int _listReq = 0;

  String _searchQuery = '';
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _payment;
  String? _status;
  Set<int> _storeIds = {};

  TransactionHistoryFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  TransactionHistoryDetail? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  List<TransactionHistoryItem> get list {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _all.length);
    if (s >= _all.length) return [];
    return _all.sublist(s, e);
  }

  bool get isLoadingList => _isLoadingList;
  bool get hasFetchedOnce => _hasFetchedOnce;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => (_all.length / _perPage).ceil().clamp(1, 99999);
  int get total => _all.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String? get selectedPayment => _payment;
  String? get selectedStatus => _status;
  Set<int> get selectedStoreIds => _storeIds;

  bool get hasActiveFilter =>
      _dateFrom != null || _payment != null || _status != null || _storeIds.isNotEmpty;
  bool get _hasCriteria => hasActiveFilter || _searchQuery.isNotEmpty;

  bool get isLoadingOptions => _isLoadingOptions;
  List<HistoryStoreOption> get storeOptions => _formOptions?.storeList ?? [];
  List<String> get paymentMethodOptions => _formOptions?.paymentMethodList ?? [];
  List<String> get statusOptions => _formOptions?.statusList ?? [];

  TransactionHistoryDetail? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;
  bool get canExportList => _hasFetchedOnce && _all.isNotEmpty && !_isExporting;

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

  void _clearData() {
    _listReq++;
    _all = [];
    _currentPage = 1;
    _hasFetchedOnce = false;
    _isLoadingList = false;
    _listError = null;
  }

  Future<void> fetchList() async {
    final req = ++_listReq;
    _isLoadingList = true;
    _hasFetchedOnce = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <TransactionHistoryItem>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          dateFrom: _fmt(_dateFrom),
          dateTo: _fmt(_dateTo),
          paymentMethod: _payment,
          status: _status,
          storeIds: _storeIds.isEmpty ? null : _storeIds.join(','),
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        if (req != _listReq) return;

        final meta = r['meta'] as TransactionHistoryPaginationMeta;
        all.addAll(r['items'] as List<TransactionHistoryItem>);
        if (p >= meta.lastPage) break;
        p++;
      }

      _all = all;
      _currentPage = 1;
    } catch (e) {
      if (req != _listReq) return;
      _listError = _msg(e);
      _all = [];
    } finally {
      if (req == _listReq) {
        _isLoadingList = false;
        notifyListeners();
      }
    }
  }

  Future<void> searchList(String q) {
    _searchQuery = q.trim();
    if (!_hasCriteria) {
      _clearData();
      notifyListeners();
      return Future.value();
    }
    return fetchList();
  }

  Future<void> applyFilters({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? paymentMethod,
    String? status,
    Set<int> storeIds = const {},
  }) {
    _dateFrom = dateFrom;
    _dateTo = dateTo;
    _payment = (paymentMethod == null || paymentMethod.isEmpty) ? null : paymentMethod;
    _status = (status == null || status.isEmpty) ? null : status;
    _storeIds = {...storeIds};

    if (!_hasCriteria) {
      _clearData();
      notifyListeners();
      return Future.value();
    }
    return fetchList();
  }

  Future<void> resetFilter() => applyFilters();

  void goToPage(int p) {
    if (p < 1 || p > lastPage) return;
    _currentPage = p;
    notifyListeners();
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  void prepareDetail() {
    _detail = null;
    _detailError = null;
    _isLoadingDetail = true;
  }

  Future<void> fetchDetail(String enc) async {
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

  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.storage.request();
    return status.isGranted || status.isLimited;
  }

  Future<void> exportList() {
    if (!canExportList) return Future.value();
    return _startDownload(
      getExportListUrl(
        dateFrom: _fmt(_dateFrom),
        dateTo: _fmt(_dateTo),
        paymentMethod: _payment,
        status: _status,
        storeIds: _storeIds.isEmpty ? null : _storeIds.join(','),
        search: _searchQuery.isEmpty ? null : _searchQuery,
      ),
      'pos_transaction_history',
    );
  }

  Future<void> exportDetail(String enc) =>
      _startDownload(getExportDetailUrl(enc), 'pos_transaction_detail');

  Future<void> _startDownload(HistoryExportUrlInfo info, String prefix) async {
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