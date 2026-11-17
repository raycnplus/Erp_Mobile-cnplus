import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/models/warehouse_report_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/domain/usecases/warehouse_report_usecases.dart';

class WarehouseTabState<T> {
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

class WarehouseReportController extends ChangeNotifier {
  final GetWarehouseReportList getWarehouseReportList;
  final GetWarehouseReportDetail getWarehouseReportDetail;
  final GetWarehouseDetailTab getWarehouseDetailTab;

  WarehouseReportController({
    required this.getWarehouseReportList,
    required this.getWarehouseReportDetail,
    required this.getWarehouseDetailTab,
  });

  List<WarehouseReportModel> _reportList = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  static const int _tabPerPage = 10;
  String _searchQuery = '';

  WarehouseReportDetailModel? _reportDetail;
  bool _isLoadingDetail = false;
  String? _detailError;
  String? _currentEncryption;

  final WarehouseTabState<WarehouseLocationModel> locations =
      WarehouseTabState();
  final WarehouseTabState<WarehouseStockModel> products = WarehouseTabState();
  final WarehouseTabState<WarehouseNoteModel> receipts = WarehouseTabState();
  final WarehouseTabState<WarehouseNoteModel> deliveries = WarehouseTabState();
  final WarehouseTabState<WarehouseTransferModel> transfers =
      WarehouseTabState();

  List<WarehouseReportModel> get reportList => _reportList;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  WarehouseReportDetailModel? get reportDetail => _reportDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  Future<void> fetchReportList({int? page}) async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final result = await getWarehouseReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
      );
      final meta = result['meta'] as WarehouseReportPaginationMeta;
      _reportList = result['items'] as List<WarehouseReportModel>;
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
      _reportDetail = await getWarehouseReportDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _reportDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  WarehouseTabState<Object?> stateOf(WarehouseDetailType type) {
    switch (type) {
      case WarehouseDetailType.locations:
        return locations;
      case WarehouseDetailType.products:
        return products;
      case WarehouseDetailType.receipts:
        return receipts;
      case WarehouseDetailType.deliveries:
        return deliveries;
      case WarehouseDetailType.transfers:
        return transfers;
    }
  }

  void ensureTabLoaded(WarehouseDetailType type) {
    final state = stateOf(type);
    if (state.loaded || state.isLoading) return;
    fetchTab(type);
  }

  void goToTabPage(WarehouseDetailType type, int page) {
    final state = stateOf(type);
    if (page < 1 || page > state.lastPage || page == state.page) return;
    fetchTab(type, page: page);
  }

  Future<void> fetchTab(WarehouseDetailType type, {int? page}) {
    switch (type) {
      case WarehouseDetailType.locations:
        return _loadTab(
          locations,
          type,
          WarehouseLocationModel.fromJson,
          page,
        );
      case WarehouseDetailType.products:
        return _loadTab(products, type, WarehouseStockModel.fromJson, page);
      case WarehouseDetailType.receipts:
        return _loadTab(receipts, type, WarehouseNoteModel.fromJson, page);
      case WarehouseDetailType.deliveries:
        return _loadTab(deliveries, type, WarehouseNoteModel.fromJson, page);
      case WarehouseDetailType.transfers:
        return _loadTab(
          transfers,
          type,
          WarehouseTransferModel.fromJson,
          page,
        );
    }
  }

  Future<void> _loadTab<T>(
    WarehouseTabState<T> state,
    WarehouseDetailType type,
    T Function(Map<String, dynamic>) parser,
    int? page,
  ) async {
    final encryption = _currentEncryption;
    if (encryption == null) return;

    state.isLoading = true;
    state.error = null;
    notifyListeners();

    try {
      final result = await getWarehouseDetailTab<T>(
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
    locations.reset();
    products.reset();
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