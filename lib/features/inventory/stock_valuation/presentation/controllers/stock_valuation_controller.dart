import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/domain/usecases/stock_valuation_usecases.dart';

class StockValuationController extends ChangeNotifier {
  final GetStockValuationWarehouseList getWarehouseList;
  final GetStockValuationWarehouseDetail getWarehouseDetail;
  final GetStockValuationBranches getBranches;

  StockValuationController({
    required this.getWarehouseList,
    required this.getWarehouseDetail,
    required this.getBranches,
  });

  // Warehouse list
  List<StockValuationWarehouseModel> _warehouses = [];
  bool _isLoadingList = false;
  String? _listError;
  String _grandTotalValuationRaw = '0';

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  String _searchQuery = '';
  String? _selectedBranch;

  List<String> _branchOptions = [];
  bool _isLoadingOptions = false;

  // Detail (per warehouse)
  StockValuationDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;
  int _detailCurrentPage = 1;
  String _detailSearchQuery = '';

  List<StockValuationWarehouseModel> get warehouses => _warehouses;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  String get grandTotalValuationRaw => _grandTotalValuationRaw;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;
  String? get selectedBranch => _selectedBranch;

  List<String> get branchOptions => _branchOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  StockValuationDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;
  int get detailCurrentPage => _detailCurrentPage;
  bool get detailHasPrevPage => _detail != null && _detailCurrentPage > 1;
  bool get detailHasNextPage => _detail != null && _detailCurrentPage < _detail!.itemsMeta.lastPage;

  Future<void> fetchBranches() async {
    _isLoadingOptions = true;
    notifyListeners();
    try {
      _branchOptions = await getBranches();
    } catch (_) {
      _branchOptions = [];
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchWarehouseList({int? page}) async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final result = await getWarehouseList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        branch: _selectedBranch,
      );
      final meta = result['meta'] as StockValuationPaginationMeta;
      _warehouses = result['items'] as List<StockValuationWarehouseModel>;
      _grandTotalValuationRaw = result['grandTotalValuationRaw'] as String;
      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;
    } catch (e) {
      _listError = _extractMessage(e);
      _warehouses = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void searchWarehouses(String query) {
    _searchQuery = query.trim();
    _currentPage = 1;
    fetchWarehouseList(page: 1);
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    fetchWarehouseList(page: 1);
  }

  void filterByBranch(String? branch) {
    _selectedBranch = branch;
    _currentPage = 1;
    fetchWarehouseList(page: 1);
  }

  void goToPage(int page) {
    if (page < 1 || page > _lastPage || page == _currentPage) return;
    fetchWarehouseList(page: page);
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  // Detail
  Future<void> fetchWarehouseDetail(int idWarehouse, {int? page}) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _detail = await getWarehouseDetail(
        idWarehouse,
        page: page ?? _detailCurrentPage,
        perPage: _perPage,
        search: _detailSearchQuery,
      );
      _detailCurrentPage = _detail!.itemsMeta.currentPage;
    } catch (e) {
      _detailError = _extractMessage(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  void searchDetailItems(int idWarehouse, String query) {
    _detailSearchQuery = query.trim();
    _detailCurrentPage = 1;
    fetchWarehouseDetail(idWarehouse, page: 1);
  }

  void detailGoToPage(int idWarehouse, int page) {
    if (_detail == null || page < 1 || page > _detail!.itemsMeta.lastPage || page == _detailCurrentPage) return;
    fetchWarehouseDetail(idWarehouse, page: page);
  }

  void detailNextPage(int idWarehouse) => detailGoToPage(idWarehouse, _detailCurrentPage + 1);
  void detailPrevPage(int idWarehouse) => detailGoToPage(idWarehouse, _detailCurrentPage - 1);

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    _detailCurrentPage = 1;
    _detailSearchQuery = '';
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}