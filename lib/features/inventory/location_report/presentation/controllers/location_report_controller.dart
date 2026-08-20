import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/data/models/location_report_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/domain/usecases/location_report_usecases.dart';

class LocationReportController extends ChangeNotifier {
  final GetLocationReportList getLocationReportList;
  final GetLocationReportDetail getLocationReportDetail;
  final GetLocationReportFormOptions getLocationReportFormOptions;

  LocationReportController({
    required this.getLocationReportList,
    required this.getLocationReportDetail,
    required this.getLocationReportFormOptions,
  });

  List<LocationReportModel> _reportList = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  String _searchQuery = '';
  int? _selectedWarehouseId;

  List<WarehouseOptionModel> _warehouseOptions = [];
  bool _isLoadingOptions = false;

  LocationReportDetailModel? _reportDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

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

  Future<void> fetchReportDetail(int idLocation) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _reportDetail = await getLocationReportDetail(idLocation);
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
