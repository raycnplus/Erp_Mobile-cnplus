import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/domain/usecases/stock_valuation_usecases.dart';

class StockValuationController extends ChangeNotifier {
  final GetStockValuationList getStockValuationList;
  final GetStockValuationDetail getStockValuationDetail;
  final GetStockValuationCostingMethods getCostingMethods;

  StockValuationController({
    required this.getStockValuationList,
    required this.getStockValuationDetail,
    required this.getCostingMethods,
  });

  List<StockValuationModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;
  StockValuationSummary? _summary;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  String _searchQuery = '';
  String? _selectedCostingMethod;

  List<String> _costingMethods = [];
  bool _isLoadingOptions = false;

  StockValuationDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  List<StockValuationModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  StockValuationSummary? get summary => _summary;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;
  String? get selectedCostingMethod => _selectedCostingMethod;

  List<String> get costingMethods => _costingMethods;
  bool get isLoadingOptions => _isLoadingOptions;

  StockValuationDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  Future<void> fetchCostingMethods() async {
    _isLoadingOptions = true;
    notifyListeners();
    try {
      _costingMethods = await getCostingMethods();
    } catch (_) {
      _costingMethods = [];
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
      final result = await getStockValuationList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        costingMethod: _selectedCostingMethod,
      );
      final meta = result['meta'] as StockValuationPaginationMeta;
      _list = result['items'] as List<StockValuationModel>;
      _summary = result['summary'] as StockValuationSummary;
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

  void filterByCostingMethod(String? method) {
    _selectedCostingMethod = method;
    _currentPage = 1;
    fetchList(page: 1);
  }

  void goToPage(int page) {
    if (page < 1 || page > _lastPage || page == _currentPage) return;
    fetchList(page: page);
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<void> fetchDetail(int idProduct) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _detail = await getStockValuationDetail(idProduct);
    } catch (e) {
      _detailError = _extractMessage(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    notifyListeners();
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}
