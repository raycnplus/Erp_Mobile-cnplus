import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/models/request_quotation_report_models.dart';

import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/domain/usecases/request_quotation_report_usecases.dart';

class RequestQuotationReportController
    extends ChangeNotifier {
  final GetRequestQuotationReportList
      getRequestQuotationReportList;

  final GetRequestQuotationReportFormOptions
      getRequestQuotationReportFormOptions;

  final GetRequestQuotationReportLocationsByWarehouse
      getLocationsByWarehouse;

  RequestQuotationReportController({
    required this.getRequestQuotationReportList,
    required this.getRequestQuotationReportFormOptions,
    required this.getLocationsByWarehouse,
  });

  // ============================================================
  // LIST STATE
  // ============================================================

  List<RequestQuotationReportModel>
      _list = [];

  bool _isLoadingList = false;

  String? _listError;

  RequestQuotationReportSummary?
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

  int? _selectedWarehouseId;

  int? _selectedLocationId;

  DateTime? _dateFrom;

  DateTime? _dateTo;

  // ============================================================
  // OPTIONS
  // ============================================================

  List<RequestQuotationVendorOption>
      _vendorOptions = [];

  List<RequestQuotationWarehouseOption>
      _warehouseOptions = [];

  List<RequestQuotationLocationOption>
      _locationOptions = [];

  bool _isLoadingOptions = false;

  bool _isLoadingLocations = false;

  String? _optionsError;

  // ============================================================
  // GETTERS
  // ============================================================

  List<RequestQuotationReportModel>
      get list => _list;

  bool get isLoadingList =>
      _isLoadingList;

  String? get listError =>
      _listError;

  RequestQuotationReportSummary?
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

  int? get selectedWarehouseId =>
      _selectedWarehouseId;

  int? get selectedLocationId =>
      _selectedLocationId;

  DateTime? get dateFrom =>
      _dateFrom;

  DateTime? get dateTo =>
      _dateTo;

  List<RequestQuotationVendorOption>
      get vendorOptions =>
          _vendorOptions;

  List<RequestQuotationWarehouseOption>
      get warehouseOptions =>
          _warehouseOptions;

  List<RequestQuotationLocationOption>
      get locationOptions =>
          _locationOptions;

  bool get isLoadingOptions =>
      _isLoadingOptions;

  bool get isLoadingLocations =>
      _isLoadingLocations;

  String? get optionsError =>
      _optionsError;

  bool get hasActiveFilter =>
      _searchQuery.isNotEmpty ||
      _selectedVendorId != null ||
      _selectedWarehouseId != null ||
      _selectedLocationId != null ||
      _dateFrom != null ||
      _dateTo != null;

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  // ============================================================
  // FETCH FORM OPTIONS
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
          await getRequestQuotationReportFormOptions();

      _warehouseOptions =
          options.warehouses;

      _vendorOptions =
          options.vendors;
    } catch (e) {
      _optionsError =
          _extractMessage(e);

      _warehouseOptions = [];

      _vendorOptions = [];
    } finally {
      _isLoadingOptions = false;

      notifyListeners();
    }
  }

  // ============================================================
  // FETCH LOCATIONS
  // ============================================================

  Future<void> fetchLocationsByWarehouse(
    int? idWarehouse,
  ) async {
    _selectedWarehouseId =
        idWarehouse;

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
          await getLocationsByWarehouse(
        idWarehouse,
      );
    } catch (e) {
      _locationOptions = [];
    } finally {
      _isLoadingLocations = false;

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
          await getRequestQuotationReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        idVendor: _selectedVendorId,
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
              as RequestQuotationReportPaginationMeta;

      _list =
          result['items']
              as List<RequestQuotationReportModel>;

      _summary =
          result['summary']
              as RequestQuotationReportSummary;

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

  void searchList(String query) {
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
  // FILTER SETTERS
  // ============================================================

  void selectVendor(
    int? idVendor,
  ) {
    _selectedVendorId =
        idVendor;

    notifyListeners();
  }

  void selectWarehouse(
    int? idWarehouse,
  ) {
    _selectedWarehouseId =
        idWarehouse;

    notifyListeners();
  }

  void selectLocation(
    int? idLocation,
  ) {
    _selectedLocationId =
        idLocation;

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

    _selectedWarehouseId = null;

    _selectedLocationId = null;

    _locationOptions = [];

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

  void goToPage(int page) {
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
  // ERROR MESSAGE
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