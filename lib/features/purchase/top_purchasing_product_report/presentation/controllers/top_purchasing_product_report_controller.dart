import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/models/top_purchasing_product_report_models.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/domain/usecases/top_purchasing_product_report_usecases.dart';

class TopPurchasingProductReportController
    extends ChangeNotifier {
  final GetTopPurchasingProductReportList
      getTopPurchasingProductReportList;

  final GetTopPurchasingProductReportFormOptions
      getTopPurchasingProductReportFormOptions;

  TopPurchasingProductReportController({
    required this.getTopPurchasingProductReportList,
    required this.getTopPurchasingProductReportFormOptions,
  });

  // ============================================================
  // LIST STATE
  // ============================================================

  List<TopPurchasingProductReportModel>
      _list = [];

  bool _isLoadingList = false;

  String? _listError;

  TopPurchasingProductReportSummary?
      _summary;

  bool _hasFetchedOnce = false;

  // ============================================================
  // PAGINATION
  // ============================================================

  int _currentPage = 1;

  int _lastPage = 1;

  int _total = 0;

  static const int _perPage = 15;

  // ============================================================
  // FILTER
  // ============================================================

  String _searchQuery = '';

  int? _selectedVendorId;

  DateTime? _dateFrom;

  DateTime? _dateTo;

  // ============================================================
  // OPTIONS
  // ============================================================

  List<TopPurchasingProductVendorOption>
      _vendorOptions = [];

  bool _isLoadingOptions = false;

  String? _optionsError;

  // ============================================================
  // GETTERS
  // ============================================================

  List<TopPurchasingProductReportModel>
      get list => _list;

  bool get isLoadingList =>
      _isLoadingList;

  String? get listError =>
      _listError;

  TopPurchasingProductReportSummary?
      get summary => _summary;

  bool get hasFetchedOnce =>
      _hasFetchedOnce;

  int get currentPage =>
      _currentPage;

  int get lastPage =>
      _lastPage;

  int get total =>
      _total;

  bool get hasPrevPage =>
      _currentPage > 1;

  bool get hasNextPage =>
      _currentPage < _lastPage;

  String get searchQuery =>
      _searchQuery;

  int? get selectedVendorId =>
      _selectedVendorId;

  DateTime? get dateFrom =>
      _dateFrom;

  DateTime? get dateTo =>
      _dateTo;

  List<TopPurchasingProductVendorOption>
      get vendorOptions =>
          _vendorOptions;

  bool get isLoadingOptions =>
      _isLoadingOptions;

  String? get optionsError =>
      _optionsError;

  bool get hasActiveFilter =>
      _searchQuery.isNotEmpty ||
      _selectedVendorId != null ||
      _dateFrom != null ||
      _dateTo != null;

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(
    DateTime d,
  ) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<void> fetchFormOptions() async {
    if (_isLoadingOptions) {
      return;
    }

    _isLoadingOptions = true;

    _optionsError = null;

    notifyListeners();

    try {
      final options =
          await getTopPurchasingProductReportFormOptions();

      _vendorOptions =
          options.vendors;
    } catch (e) {
      _optionsError =
          _extractMessage(e);

      _vendorOptions = [];
    } finally {
      _isLoadingOptions = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FETCH LIST
  // ============================================================

  Future<void> fetchList({
    int? page,
  }) async {
    _isLoadingList = true;

    _listError = null;

    _hasFetchedOnce = true;

    notifyListeners();

    try {
      final result =
          await getTopPurchasingProductReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        idVendor:
            _selectedVendorId,
        dateFrom:
            _dateFrom != null
                ? _formatDate(
                    _dateFrom!,
                  )
                : null,
        dateTo:
            _dateTo != null
                ? _formatDate(
                    _dateTo!,
                  )
                : null,
      );

      final meta =
          result['meta']
              as TopPurchasingProductReportPaginationMeta;

      _list =
          result['items']
              as List<
                  TopPurchasingProductReportModel>;

      _summary =
          result['summary']
              as TopPurchasingProductReportSummary;

      _currentPage =
          meta.currentPage;

      _lastPage =
          meta.lastPage;

      _total =
          meta.total;
    } catch (e) {
      _listError =
          _extractMessage(e);

      _list = [];
    } finally {
      _isLoadingList = false;

      notifyListeners();
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchList(
    String query,
  ) {
    _searchQuery =
        query.trim();

    _currentPage = 1;

    fetchList(
      page: 1,
    );
  }

  void clearSearch() {
    _searchQuery = '';

    _currentPage = 1;

    if (_hasFetchedOnce) {
      fetchList(
        page: 1,
      );
    }
  }

  // ============================================================
  // FILTER
  // ============================================================

  void selectVendor(
    int? idVendor,
  ) {
    _selectedVendorId =
        idVendor;

    notifyListeners();
  }

  void setDateRange(
    DateTime? from,
    DateTime? to,
  ) {
    _dateFrom = from;

    _dateTo = to;

    notifyListeners();
  }

  // ============================================================
  // APPLY FILTER
  // ============================================================

  void applyFilter() {
    _currentPage = 1;

    fetchList(
      page: 1,
    );
  }

  // ============================================================
  // RESET FILTER
  // ============================================================

  void resetFilter() {
    _searchQuery = '';

    _selectedVendorId = null;

    _dateFrom = null;

    _dateTo = null;

    _currentPage = 1;

    fetchList(
      page: 1,
    );
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  void goToPage(
    int page,
  ) {
    if (page < 1 ||
        page > _lastPage ||
        page == _currentPage) {
      return;
    }

    fetchList(
      page: page,
    );
  }

  void nextPage() {
    goToPage(
      _currentPage + 1,
    );
  }

  void prevPage() {
    goToPage(
      _currentPage - 1,
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _extractMessage(
    dynamic error,
  ) =>
      error
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
}