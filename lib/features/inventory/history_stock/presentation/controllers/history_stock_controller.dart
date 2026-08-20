import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/models/history_stock_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/domain/usecases/history_stock_usecases.dart';

class HistoryStockController extends ChangeNotifier {
  final GetHistoryStockList getHistoryStockList;
  final GetHistoryTransactions getHistoryTransactions;
  final GetHistoryStockFormOptions getHistoryStockFormOptions;
  final GetHistoryStockLocationsByWarehouse getLocationsByWarehouse;

  HistoryStockController({
    required this.getHistoryStockList,
    required this.getHistoryTransactions,
    required this.getHistoryStockFormOptions,
    required this.getLocationsByWarehouse,
  });

  // List (daily summary per product/location)
  List<HistoryStockModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;
  HistoryStockSummary? _summary;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;

  // Filters
  int? _selectedWarehouseId;
  int? _selectedLocationId;
  int? _selectedProductId;
  DateTime _selectedDate = DateTime.now();

  List<HistoryWarehouseOption> _warehouseOptions = [];
  List<HistoryProductOption> _productOptions = [];
  List<HistoryLocationOption> _locationOptions = [];
  bool _isLoadingOptions = false;
  bool _isLoadingLocations = false;

  // Transactions (drill-down)
  List<HistoryTransactionModel> _transactions = [];
  bool _isLoadingTransactions = false;
  String? _transactionsError;
  int _txCurrentPage = 1;
  int _txLastPage = 1;
  int _txTotal = 0;
  String _txSearchQuery = '';

  // Getters - list
  List<HistoryStockModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  HistoryStockSummary? get summary => _summary;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  int? get selectedWarehouseId => _selectedWarehouseId;
  int? get selectedLocationId => _selectedLocationId;
  int? get selectedProductId => _selectedProductId;
  DateTime get selectedDate => _selectedDate;

  List<HistoryWarehouseOption> get warehouseOptions => _warehouseOptions;
  List<HistoryProductOption> get productOptions => _productOptions;
  List<HistoryLocationOption> get locationOptions => _locationOptions;
  bool get isLoadingOptions => _isLoadingOptions;
  bool get isLoadingLocations => _isLoadingLocations;

  bool get hasActiveFilter =>
      _selectedWarehouseId != null ||
      _selectedLocationId != null ||
      _selectedProductId != null;

  // Getters - transactions
  List<HistoryTransactionModel> get transactions => _transactions;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get transactionsError => _transactionsError;
  int get txCurrentPage => _txCurrentPage;
  int get txLastPage => _txLastPage;
  int get txTotal => _txTotal;
  bool get txHasPrevPage => _txCurrentPage > 1;
  bool get txHasNextPage => _txCurrentPage < _txLastPage;

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String? _optionsError;
  String? get optionsError => _optionsError;

  Future<void> fetchFormOptions() async {
    _isLoadingOptions = true;
    _optionsError = null;
    notifyListeners();
    try {
      final options = await getHistoryStockFormOptions();
      _warehouseOptions = options['warehouses'] as List<HistoryWarehouseOption>;
      _productOptions = options['products'] as List<HistoryProductOption>;
      final todayStr = options['today'] as String;
      if (todayStr.isNotEmpty) {
        _selectedDate = DateTime.tryParse(todayStr) ?? DateTime.now();
      }
    } catch (e) {
      _optionsError = e.toString();
      debugPrint('HistoryStock formOptions error: $e');
      _warehouseOptions = [];
      _productOptions = [];
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
      final result = await getHistoryStockList(
        page: page ?? _currentPage,
        perPage: _perPage,
        date: _formatDate(_selectedDate),
        idWarehouse: _selectedWarehouseId,
        idLocation: _selectedLocationId,
        idProduct: _selectedProductId,
      );
      final meta = result['meta'] as HistoryStockPaginationMeta;
      _list = result['items'] as List<HistoryStockModel>;
      _summary = result['summary'] as HistoryStockSummary;
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

  void selectProduct(int? idProduct) {
    _selectedProductId = idProduct;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void applyFilter() {
    _currentPage = 1;
    fetchList(page: 1);
  }

  void resetFilter() {
    _selectedWarehouseId = null;
    _selectedLocationId = null;
    _selectedProductId = null;
    _locationOptions = [];
    _selectedDate = DateTime.now();
    _currentPage = 1;
    fetchList(page: 1);
  }

  void goToPage(int page) {
    if (page < 1 || page > _lastPage || page == _currentPage) return;
    fetchList(page: page);
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  // Transactions drill-down
  Future<void> fetchTransactions({int? page}) async {
    _isLoadingTransactions = true;
    _transactionsError = null;
    notifyListeners();

    try {
      final result = await getHistoryTransactions(
        page: page ?? _txCurrentPage,
        perPage: _perPage,
        search: _txSearchQuery,
        idWarehouse: _selectedWarehouseId,
        idLocation: _selectedLocationId,
        idProduct: _selectedProductId,
        date: _formatDate(_selectedDate),
      );
      final meta = result['meta'] as HistoryStockPaginationMeta;
      _transactions = result['items'] as List<HistoryTransactionModel>;
      _txCurrentPage = meta.currentPage;
      _txLastPage = meta.lastPage;
      _txTotal = meta.total;
    } catch (e) {
      _transactionsError = _extractMessage(e);
      _transactions = [];
    } finally {
      _isLoadingTransactions = false;
      notifyListeners();
    }
  }

  void searchTransactions(String query) {
    _txSearchQuery = query.trim();
    _txCurrentPage = 1;
    fetchTransactions(page: 1);
  }

  void txGoToPage(int page) {
    if (page < 1 || page > _txLastPage || page == _txCurrentPage) return;
    fetchTransactions(page: page);
  }

  void txNextPage() => txGoToPage(_txCurrentPage + 1);
  void txPrevPage() => txGoToPage(_txCurrentPage - 1);

  void resetTransactionsState() {
    _transactions = [];
    _transactionsError = null;
    _txCurrentPage = 1;
    _txSearchQuery = '';
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}
