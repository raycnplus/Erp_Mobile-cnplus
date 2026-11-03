import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/models/top_customer_report_models.dart';
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/domain/usecases/top_customer_report_usecases.dart';

class TopCustomerReportController extends ChangeNotifier {
  final GetTopCustomerReportList getList;
  final GetTopCustomerReportFormOptions getFormOptions;

  TopCustomerReportController({
    required this.getList,
    required this.getFormOptions,
  });

  static const int _perPage = 15;

  List<TopCustomerReportItem> _all = [];
  List<TopCustomerReportItem> _filtered = [];
  bool _isLoadingList = false;
  bool _hasFetchedOnce = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';

  DateTime? _dateFrom;
  DateTime? _dateTo;
  int? _idStore;

  TopCustomerReportFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  List<TopCustomerReportItem> get list {
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

  TopCustomerReportFormOptions? get formOptions => _formOptions;
  List<StoreOption> get storeOptions => _formOptions?.storeList ?? [];
  bool get isLoadingOptions => _isLoadingOptions;

  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  int? get selectedStoreId => _idStore;

  bool get hasActiveFilter => _idStore != null || _dateFrom != null || _dateTo != null;

  double get grandTotalAmount => _filtered.fold(0.0, (s, e) => s + e.totalAmount);
  int get grandTotalTransaction => _filtered.fold(0, (s, e) => s + e.totalTransaction);

  void selectStore(int? value) => _idStore = value;

  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;
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

  Future<void> fetchList() async {
    _isLoadingList = true;
    _hasFetchedOnce = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <TopCustomerReportItem>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          dateFrom: _fmt(_dateFrom),
          dateTo: _fmt(_dateTo),
          idStore: _idStore?.toString(),
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as TopCustomerReportPaginationMeta;
        all.addAll(r['items'] as List<TopCustomerReportItem>);
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
    _filtered = _all.where((t) {
      return t.customer.toLowerCase().contains(q) || t.store.toLowerCase().contains(q);
    }).toList();
  }

  void searchList(String q) {
    _searchQuery = q.trim();
    _currentPage = 1;
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
    _searchQuery = '';
    _dateFrom = null;
    _dateTo = null;
    _all = [];
    _filtered = [];
    _currentPage = 1;
    _hasFetchedOnce = false;
    _listError = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}