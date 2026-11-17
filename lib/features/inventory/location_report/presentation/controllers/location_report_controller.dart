import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/data/models/location_report_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/domain/usecases/location_report_usecases.dart';

class LocationTabState<T> {
  List<T> items = [];
  bool isLoading = false;
  bool loaded = false;
  String? error;
  int page = 1;
  int lastPage = 1;
  int total = 0;

  bool get hasPrev => page > 1;
  bool get hasNext => page < lastPage;

  void reset() {
    items = [];
    isLoading = false;
    loaded = false;
    error = null;
    page = 1;
    lastPage = 1;
    total = 0;
  }
}

class LocationReportController extends ChangeNotifier {
  final GetLocationReportList getLocationReportList;
  final GetLocationReportDetail getLocationReportDetail;
  final GetLocationDetailTab getLocationDetailTab;
  final GetLocationReportFormOptions getLocationReportFormOptions;

  LocationReportController({
    required this.getLocationReportList,
    required this.getLocationReportDetail,
    required this.getLocationDetailTab,
    required this.getLocationReportFormOptions,
  });

  List<LocationReportModel> _reportList = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  static const int _tabPerPage = 10;
  String _searchQuery = '';
  int? _selectedWarehouseId;

  List<WarehouseOptionModel> _warehouseOptions = [];
  bool _isLoadingOptions = false;

  LocationReportDetailModel? _reportDetail;
  bool _isLoadingDetail = false;
  String? _detailError;
  String? _currentEncryption;

  final LocationTabState<LocationStockModel> products = LocationTabState();
  final LocationTabState<LocationChildModel> children = LocationTabState();
  final LocationTabState<LocationNoteModel> receipts = LocationTabState();
  final LocationTabState<LocationNoteModel> deliveries = LocationTabState();
  final LocationTabState<LocationTransferModel> transfers = LocationTabState();

  List<LocationReportModel> get reportList => _reportList;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;
  int? get selectedWarehouseId => _selectedWarehouseId;

  List<WarehouseOptionModel> get warehouseOptions => _warehouseOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  LocationReportDetailModel? get reportDetail => _reportDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  Future<void> fetchFormOptions() async {
    _isLoadingOptions = true;
    notifyListeners();
    try {
      _warehouseOptions = await getLocationReportFormOptions();
    } catch (_) {
      _warehouseOptions = [];
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchReportList({int? page}) async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final result = await getLocationReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        idWarehouse: _selectedWarehouseId,
      );
      final meta = result['meta'] as LocationReportPaginationMeta;
      _reportList = result['items'] as List<LocationReportModel>;
      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;
    } catch (e) {
      _listError = _extractMessage(e);
      _reportList = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void searchReports(String query) {
    _searchQuery = query.trim();
    _currentPage = 1;
    fetchReportList(page: 1);
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    fetchReportList(page: 1);
  }

  void filterByWarehouse(int? idWarehouse) {
    _selectedWarehouseId = idWarehouse;
    _currentPage = 1;
    fetchReportList(page: 1);
  }

  void goToPage(int page) {
    if (page < 1 || page > _lastPage || page == _currentPage) return;
    fetchReportList(page: page);
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<void> fetchReportDetail(String encryption) async {
    _currentEncryption = encryption;
    _resetTabs();
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _reportDetail = await getLocationReportDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _reportDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  LocationTabState<Object?> stateOf(LocationDetailType type) {
    switch (type) {
      case LocationDetailType.products:
        return products;
      case LocationDetailType.children:
        return children;
      case LocationDetailType.receipts:
        return receipts;
      case LocationDetailType.deliveries:
        return deliveries;
      case LocationDetailType.transfers:
        return transfers;
    }
  }

  void ensureTabLoaded(LocationDetailType type) {
    final state = stateOf(type);
    if (state.loaded || state.isLoading) return;
    fetchTab(type);
  }

  void goToTabPage(LocationDetailType type, int page) {
    final state = stateOf(type);
    if (page < 1 || page > state.lastPage || page == state.page) return;
    fetchTab(type, page: page);
  }

  Future<void> fetchTab(LocationDetailType type, {int? page}) {
    switch (type) {
      case LocationDetailType.products:
        return _loadTab(products, type, LocationStockModel.fromJson, page);
      case LocationDetailType.children:
        return _loadTab(children, type, LocationChildModel.fromJson, page);
      case LocationDetailType.receipts:
        return _loadTab(receipts, type, LocationNoteModel.fromJson, page);
      case LocationDetailType.deliveries:
        return _loadTab(deliveries, type, LocationNoteModel.fromJson, page);
      case LocationDetailType.transfers:
        return _loadTab(transfers, type, LocationTransferModel.fromJson, page);
    }
  }

  Future<void> _loadTab<T>(
    LocationTabState<T> state,
    LocationDetailType type,
    T Function(Map<String, dynamic>) parser,
    int? page,
  ) async {
    final encryption = _currentEncryption;
    if (encryption == null) return;

    state.isLoading = true;
    state.error = null;
    notifyListeners();

    try {
      final result = await getLocationDetailTab<T>(
        encryption: encryption,
        type: type.name,
        parser: parser,
        page: page ?? state.page,
        perPage: _tabPerPage,
      );
      state.items = result.items;
      state.page = result.meta.page;
      state.lastPage = result.meta.lastPage;
      state.total = result.meta.total;
      state.loaded = true;
    } catch (e) {
      state.error = _extractMessage(e);
      state.items = [];
    } finally {
      state.isLoading = false;
      notifyListeners();
    }
  }

  void _resetTabs() {
    products.reset();
    children.reset();
    receipts.reset();
    deliveries.reset();
    transfers.reset();
  }

  void resetDetailState() {
    _reportDetail = null;
    _detailError = null;
    _currentEncryption = null;
    _resetTabs();
    notifyListeners();
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}