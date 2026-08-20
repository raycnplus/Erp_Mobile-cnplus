import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/models/stock_report_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/domain/usecases/stock_report_usecases.dart';

class StockReportController extends ChangeNotifier {
  final GetStockReportList getStockReportList;
  final GetStockReportDetail getStockReportDetail;

  StockReportController({
    required this.getStockReportList,
    required this.getStockReportDetail,
  });

  List<StockReportModel> _reportList = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  String _searchQuery = '';

  StockReportDetailModel? _reportDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  List<StockReportModel> get reportList => _reportList;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  StockReportDetailModel? get reportDetail => _reportDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  Future<void> fetchReportList({int? page}) async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final result = await getStockReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
      );
      final meta = result['meta'] as StockReportPaginationMeta;
      _reportList = result['items'] as List<StockReportModel>;
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

  Future<void> fetchReportDetail(int idProduct) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _reportDetail = await getStockReportDetail(idProduct);
    } catch (e) {
      _detailError = _extractMessage(e);
      _reportDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _reportDetail = null;
    _detailError = null;
    notifyListeners();
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}
