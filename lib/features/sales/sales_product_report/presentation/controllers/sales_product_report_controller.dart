import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/data/models/sales_product_report_models.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/domain/usecases/sales_product_report_usecases.dart';

class SalesProductReportController extends ChangeNotifier {
  final GetSalesProductReportList getSalesProductReportList;
  final GetSalesProductReportFormOptions getSalesProductReportFormOptions;

  SalesProductReportController({
    required this.getSalesProductReportList,
    required this.getSalesProductReportFormOptions,
  });

  // ============================================================
  // LIST
  // ============================================================

  List<SalesProductReportModel> _list = [];

  bool _isLoadingList = false;
  String? _listError;

  SalesProductReportSummary? _summary;

  // True jika user sudah pernah melakukan Apply Filter
  bool _hasFetchedOnce = false;

  // ============================================================
  // PAGINATION
  // ============================================================

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  static const int _perPage = 15;

  // ============================================================
  // SEARCH
  // ============================================================

  String _searchQuery = '';

  // ============================================================
  // FILTER
  // ============================================================

  int? _selectedProductId;
  int? _selectedCategoryId;

  DateTime? _dateFrom;
  DateTime? _dateTo;

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  List<SalesProductOption> _productOptions = [];
  List<SalesProductCategoryOption> _categoryOptions = [];

  bool _isLoadingOptions = false;
  String? _optionsError;

  // ============================================================
  // GETTERS
  // ============================================================

  List<SalesProductReportModel> get list => _list;

  bool get isLoadingList => _isLoadingList;

  String? get listError => _listError;

  SalesProductReportSummary? get summary => _summary;

  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;

  int get lastPage => _lastPage;

  int get total => _total;

  bool get hasPrevPage => _currentPage > 1;

  bool get hasNextPage => _currentPage < _lastPage;

  int? get selectedProductId => _selectedProductId;

  int? get selectedCategoryId => _selectedCategoryId;

  DateTime? get dateFrom => _dateFrom;

  DateTime? get dateTo => _dateTo;

  List<SalesProductOption> get productOptions =>
      List.unmodifiable(_productOptions);

  List<SalesProductCategoryOption> get categoryOptions =>
      List.unmodifiable(_categoryOptions);

  bool get isLoadingOptions => _isLoadingOptions;

  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      _selectedProductId != null ||
      _selectedCategoryId != null ||
      _dateFrom != null ||
      _dateTo != null;

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // FORM OPTIONS
  // ============================================================

  Future<void> fetchFormOptions() async {
    _isLoadingOptions = true;
    _optionsError = null;

    notifyListeners();

    try {
      final options =
          await getSalesProductReportFormOptions();

      _productOptions =
          options['products'] as List<SalesProductOption>;

      _categoryOptions =
          options['categories']
              as List<SalesProductCategoryOption>;
    } catch (e) {
      _optionsError = e.toString();

      _productOptions = [];
      _categoryOptions = [];
    } finally {
      _isLoadingOptions = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FETCH LIST
  // ============================================================

  Future<void> fetchList({int? page}) async {
    _isLoadingList = true;
    _listError = null;

    notifyListeners();

    try {
      final result = await getSalesProductReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery.isNotEmpty
            ? _searchQuery
            : null,
        idProduct: _selectedProductId,
        idCategory: _selectedCategoryId,
        dateFrom: _dateFrom != null
            ? _formatDate(_dateFrom!)
            : null,
        dateTo: _dateTo != null
            ? _formatDate(_dateTo!)
            : null,
      );

      final meta =
          result['meta']
              as SalesProductReportPaginationMeta;

      _list =
          result['items']
              as List<SalesProductReportModel>;

      _summary =
          result['summary']
              as SalesProductReportSummary;

      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;

      // Baru true setelah request report berhasil
      _hasFetchedOnce = true;
    } catch (e) {
      _listError = _extractMessage(e);
      _list = [];

      // Tetap false kalau request pertama gagal
      if (!_hasFetchedOnce) {
        _hasFetchedOnce = false;
      }
    } finally {
      _isLoadingList = false;

      notifyListeners();
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchList(String query) {
    _searchQuery = query.trim();
    _currentPage = 1;

    // Kalau belum pernah Apply Filter, jangan otomatis
    // menampilkan report.
    if (!_hasFetchedOnce) {
      notifyListeners();
      return;
    }

    fetchList(page: 1);
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;

    if (!_hasFetchedOnce) {
      notifyListeners();
      return;
    }

    fetchList(page: 1);
  }

  // ============================================================
  // FILTER
  // ============================================================

  void selectProduct(int? idProduct) {
    _selectedProductId = idProduct;
    notifyListeners();
  }

  void selectCategory(int? idCategory) {
    _selectedCategoryId = idCategory;
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

    // Apply = baru load report
    fetchList(page: 1);
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetFilter() {
    _selectedProductId = null;
    _selectedCategoryId = null;
    _dateFrom = null;
    _dateTo = null;

    _searchQuery = '';

    _currentPage = 1;

    // Setelah Reset, jangan langsung load data.
    _list = [];
    _summary = null;
    _total = 0;
    _lastPage = 1;
    _hasFetchedOnce = false;
    _listError = null;

    notifyListeners();
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  void goToPage(int page) {
    if (page < 1 ||
        page > _lastPage ||
        page == _currentPage) {
      return;
    }

    fetchList(page: page);
  }

  void nextPage() {
    goToPage(_currentPage + 1);
  }

  void prevPage() {
    goToPage(_currentPage - 1);
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _extractMessage(dynamic error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }
}