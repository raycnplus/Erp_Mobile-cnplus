import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/models/direct_purchase_report_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/domain/usecases/direct_purchase_report_usecases.dart';

class DirectPurchaseReportController extends ChangeNotifier {
  final GetDirectPurchaseReportList getDirectPurchaseReportList;
  final GetDirectPurchaseReportFormOptions getDirectPurchaseReportFormOptions;
  final GetDirectPurchaseReportLocationsByWarehouse getLocationsByWarehouse;
  final GetDirectPurchaseReportExportPdfUrl getExportPdfUrl;
  final GetDirectPurchaseReportExportExcelUrl getExportExcelUrl;

  DirectPurchaseReportController({
    required this.getDirectPurchaseReportList,
    required this.getDirectPurchaseReportFormOptions,
    required this.getLocationsByWarehouse,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  List<DirectPurchaseReportModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;
  DirectPurchaseReportSummary? _summary;
  bool _hasFetchedOnce = false;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;

  String _searchQuery = '';
  int? _selectedVendorId;
  int? _selectedWarehouseId;
  int? _selectedLocationId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  List<DirectPurchaseVendorOption> _vendorOptions = [];
  List<DirectPurchaseWarehouseOption> _warehouseOptions = [];
  List<DirectPurchaseLocationOption> _locationOptions = [];
  bool _isLoadingOptions = false;
  bool _isLoadingLocations = false;
  String? _optionsError;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  List<DirectPurchaseReportModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  DirectPurchaseReportSummary? get summary => _summary;
  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  String get searchQuery => _searchQuery;
  int? get selectedVendorId => _selectedVendorId;
  int? get selectedWarehouseId => _selectedWarehouseId;
  int? get selectedLocationId => _selectedLocationId;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;

  List<DirectPurchaseVendorOption> get vendorOptions => _vendorOptions;
  List<DirectPurchaseWarehouseOption> get warehouseOptions => _warehouseOptions;
  List<DirectPurchaseLocationOption> get locationOptions => _locationOptions;
  bool get isLoadingOptions => _isLoadingOptions;
  bool get isLoadingLocations => _isLoadingLocations;
  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      _searchQuery.isNotEmpty ||
      _selectedVendorId != null ||
      _selectedWarehouseId != null ||
      _selectedLocationId != null ||
      _dateFrom != null ||
      _dateTo != null;

  bool get canExport => _hasFetchedOnce && _list.isNotEmpty;
  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> fetchFormOptions() async {
    if (_isLoadingOptions) return;

    _isLoadingOptions = true;
    _optionsError = null;
    notifyListeners();

    try {
      final options = await getDirectPurchaseReportFormOptions();
      _warehouseOptions = options.warehouses;
      _vendorOptions = options.vendors;
    } catch (e) {
      _optionsError = _extractMessage(e);
      _warehouseOptions = [];
      _vendorOptions = [];
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchLocationsByWarehouse(int? idWarehouse) async {
    _selectedWarehouseId = idWarehouse;
    _selectedLocationId = null;
    _locationOptions = [];
    notifyListeners();

    if (idWarehouse == null) return;

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

  Future<void> fetchList({int? page}) async {
    _isLoadingList = true;
    _listError = null;
    _hasFetchedOnce = true;
    notifyListeners();

    try {
      final result = await getDirectPurchaseReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        idVendor: _selectedVendorId,
        idWarehouse: _selectedWarehouseId,
        idLocation: _selectedLocationId,
        dateFrom: _dateFrom != null ? _formatDate(_dateFrom!) : null,
        dateTo: _dateTo != null ? _formatDate(_dateTo!) : null,
      );

      final meta = result['meta'] as DirectPurchaseReportPaginationMeta;

      _list = result['items'] as List<DirectPurchaseReportModel>;
      _summary = result['summary'] as DirectPurchaseReportSummary;
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

    if (_hasFetchedOnce) {
      fetchList(page: 1);
    }
  }

  void selectVendor(int? idVendor) {
    _selectedVendorId = idVendor;
    notifyListeners();
  }

  void selectWarehouse(int? idWarehouse) {
    _selectedWarehouseId = idWarehouse;
    notifyListeners();
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
    _searchQuery = '';
    _selectedVendorId = null;
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

  Future<void> startExport(String type) async {
    if (!canExport || _isExporting) return;

    final from = _dateFrom != null ? _formatDate(_dateFrom!) : null;
    final to = _dateTo != null ? _formatDate(_dateTo!) : null;

    final DirectPurchaseReportExportUrlInfo info = type == 'pdf'
        ? getExportPdfUrl(
            idVendor: _selectedVendorId,
            idWarehouse: _selectedWarehouseId,
            idLocation: _selectedLocationId,
            dateFrom: from,
            dateTo: to,
          )
        : getExportExcelUrl(
            idVendor: _selectedVendorId,
            idWarehouse: _selectedWarehouseId,
            idLocation: _selectedLocationId,
            dateFrom: from,
            dateTo: to,
          );

    final ext = type == 'pdf' ? 'pdf' : 'xlsx';

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    _currentTaskId = await DownloadService.instance.download(
      url: info.url,
      headers: info.headers,
      fileName: 'direct_purchase_report_${DateTime.now().millisecondsSinceEpoch}.$ext',
      label: 'Direct Purchase Report ${type.toUpperCase()}',
      onProgress: (p) {
        _downloadProgress = p;
        notifyListeners();
      },
      onMessage: (m) {
        _statusMessage = m;
        notifyListeners();
      },
      onFinished: () {
        _isExporting = false;
        _currentTaskId = null;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    if (_currentTaskId != null) {
      DownloadService.instance.unlisten(_currentTaskId!);
    }
    super.dispose();
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}