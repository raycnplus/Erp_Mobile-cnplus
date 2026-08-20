import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/models/stock_movement_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/domain/usecases/stock_movement_usecases.dart';

class StockMovementController extends ChangeNotifier {
  final GetStockMovementList getStockMovementList;
  final GetStockMovementFormOptions getStockMovementFormOptions;
  final GetStockMovementLocationsByWarehouse getLocationsByWarehouse;

  StockMovementController({
    required this.getStockMovementList,
    required this.getStockMovementFormOptions,
    required this.getLocationsByWarehouse,
  });

  List<StockMovementModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  String _searchQuery = '';

  int? _selectedWarehouseId;
  int? _selectedLocationId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  List<WarehouseOptionModel> _warehouseOptions = [];
  List<LocationOptionModel> _locationOptions = [];
  bool _isLoadingOptions = false;
  bool _isLoadingLocations = false;

  List<StockMovementModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  int? get selectedWarehouseId => _selectedWarehouseId;
  int? get selectedLocationId => _selectedLocationId;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;

  List<WarehouseOptionModel> get warehouseOptions => _warehouseOptions;
  List<LocationOptionModel> get locationOptions => _locationOptions;
  bool get isLoadingOptions => _isLoadingOptions;
  bool get isLoadingLocations => _isLoadingLocations;

  bool get hasActiveFilter =>
      _selectedWarehouseId != null ||
      _selectedLocationId != null ||
      _dateFrom != null ||
      _dateTo != null;

  Future<void> fetchFormOptions() async {
    _isLoadingOptions = true;
    notifyListeners();
    try {
      final options = await getStockMovementFormOptions();
      _warehouseOptions = options.warehouses;
    } catch (_) {
      _warehouseOptions = [];
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchList({int? page}) async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final result = await getStockMovementList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        idWarehouse: _selectedWarehouseId,
        idLocation: _selectedLocationId,
        dateFrom: _dateFrom != null ? _formatDate(_dateFrom!) : null,
        dateTo: _dateTo != null ? _formatDate(_dateTo!) : null,
      );
      final meta = result['meta'] as StockMovementPaginationMeta;
      _list = result['items'] as List<StockMovementModel>;
      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;
    } catch (e) {
      _listError = _extractMessage(e);
      _list = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void searchList(String query) {
    _searchQuery = query.trim();
    _currentPage = 1;
    fetchList(page: 1);
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    fetchList(page: 1);
  }

  Future<void> selectWarehouse(int? idWarehouse) async {
    _selectedWarehouseId = idWarehouse;
    _selectedLocationId = null;
    _locationOptions = [];
    notifyListeners();

    if (idWarehouse != null) {
      _isLoadingLocations = true;
      notifyListeners();
      try {
        _locationOptions = await getLocationsByWarehouse(idWarehouse);
      } catch (_) {
        _locationOptions = [];
      } finally {
        _isLoadingLocations = false;
        notifyListeners();
      }
    }
  }

  void selectLocation(int? idLocation) {
    _selectedLocationId = idLocation;
    notifyListeners();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;
    notifyListeners();
  }

  void applyFilter() {
    _currentPage = 1;
    fetchList(page: 1);
  }

  void resetFilter() {
    _selectedWarehouseId = null;
    _selectedLocationId = null;
    _locationOptions = [];
    _dateFrom = null;
    _dateTo = null;
    _currentPage = 1;
    fetchList(page: 1);
  }

  void goToPage(int page) {
    if (page < 1 || page > _lastPage || page == _currentPage) return;
    fetchList(page: page);
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}
