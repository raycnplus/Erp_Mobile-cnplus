import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/models/top_customer_report_models.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/domain/usecases/top_customer_report_usecases.dart';

class TopCustomerReportController extends ChangeNotifier {
  final GetTopCustomerReportList getTopCustomerReportList;
  final GetTopCustomerReportFormOptions getTopCustomerReportFormOptions;
  final GetTopCustomerReportLocationsByWarehouse getLocationsByWarehouse;

  TopCustomerReportController({
    required this.getTopCustomerReportList,
    required this.getTopCustomerReportFormOptions,
    required this.getLocationsByWarehouse,
  });

  // ============================================================
  // LIST
  // ============================================================

  List<TopCustomerReportModel> _list = [];

  bool _isLoadingList = false;
  String? _listError;

  TopCustomerReportSummary? _summary;

  // True setelah user melakukan Apply Filter
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

  int? _selectedWarehouseId;
  int? _selectedLocationId;

  DateTime? _dateFrom;
  DateTime? _dateTo;

  // ============================================================
  // OPTIONS
  // ============================================================

  List<TopCustomerWarehouseOption> _warehouseOptions = [];
  List<TopCustomerLocationOption> _locationOptions = [];

  bool _isLoadingOptions = false;
  bool _isLoadingLocations = false;

  String? _optionsError;

  // ============================================================
  // GETTERS
  // ============================================================

  List<TopCustomerReportModel> get list => _list;

  bool get isLoadingList => _isLoadingList;

  String? get listError => _listError;

  TopCustomerReportSummary? get summary => _summary;

  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;

  int get lastPage => _lastPage;

  int get total => _total;

  bool get hasPrevPage => _currentPage > 1;

  bool get hasNextPage => _currentPage < _lastPage;

  int? get selectedWarehouseId => _selectedWarehouseId;

  int? get selectedLocationId => _selectedLocationId;

  DateTime? get dateFrom => _dateFrom;

  DateTime? get dateTo => _dateTo;

  List<TopCustomerWarehouseOption> get warehouseOptions =>
      List.unmodifiable(_warehouseOptions);

  List<TopCustomerLocationOption> get locationOptions =>
      List.unmodifiable(_locationOptions);

  bool get isLoadingOptions => _isLoadingOptions;

  bool get isLoadingLocations => _isLoadingLocations;

  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      _selectedWarehouseId != null ||
      _selectedLocationId != null ||
      _dateFrom != null ||
      _dateTo != null;

  // ============================================================
  // DATE
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
      _warehouseOptions =
          await getTopCustomerReportFormOptions();
    } catch (e) {
      _optionsError = e.toString();
      _warehouseOptions = [];
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
      final result = await getTopCustomerReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery.isNotEmpty
            ? _searchQuery
            : null,
        idWarehouse: _selectedWarehouseId,
        idLocation: _selectedLocationId,
        dateFrom: _dateFrom != null
            ? _formatDate(_dateFrom!)
            : null,
        dateTo: _dateTo != null
            ? _formatDate(_dateTo!)
            : null,
      );

      final meta =
          result['meta']
              as TopCustomerReportPaginationMeta;

      _list =
          result['items']
              as List<TopCustomerReportModel>;

      _summary =
          result['summary']
              as TopCustomerReportSummary;

      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;

      // Report sudah pernah dijalankan
      _hasFetchedOnce = true;
    } catch (e) {
      _listError = _extractMessage(e);
      _list = [];

      // Pada request pertama gagal, tetap dianggap belum pernah fetch
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

    // Sebelum Apply Filter, search tidak langsung
    // menjalankan report.
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
  // WAREHOUSE
  // ============================================================

  Future<void> selectWarehouse(int? idWarehouse) async {
    _selectedWarehouseId = idWarehouse;
    _selectedLocationId = null;
    _locationOptions = [];

    notifyListeners();

    if (idWarehouse == null) {
      return;
    }

    _isLoadingLocations = true;
    notifyListeners();

    try {
      _locationOptions =
          await getLocationsByWarehouse(idWarehouse);
    } catch (_) {
      _locationOptions = [];
    } finally {
      _isLoadingLocations = false;
      notifyListeners();
    }
  }

  // ============================================================
  // LOCATION
  // ============================================================

  void selectLocation(int? idLocation) {
    _selectedLocationId = idLocation;
    notifyListeners();
  }

  // ============================================================
  // DATE RANGE
  // ============================================================

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

    fetchList(page: 1);
  }

  // ============================================================
  // RESET FILTER
  // ============================================================

  void resetFilter() {
    _selectedWarehouseId = null;
    _selectedLocationId = null;

    _locationOptions = [];

    _dateFrom = null;
    _dateTo = null;

    _searchQuery = '';

    _currentPage = 1;
    _lastPage = 1;
    _total = 0;

    _list = [];
    _summary = null;
    _listError = null;

    // Kembali ke kondisi awal:
    // user harus Apply Filter lagi.
    _hasFetchedOnce = false;

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
    return error.toString().replaceFirst(
          'Exception: ',
          '',
        );
  }
}