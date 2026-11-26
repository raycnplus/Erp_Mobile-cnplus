import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/models/request_quotation_report_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/domain/usecases/request_quotation_report_usecases.dart';

class RequestQuotationReportController extends ChangeNotifier {
  final GetRequestQuotationReportList getRequestQuotationReportList;
  final GetRequestQuotationReportFormOptions getRequestQuotationReportFormOptions;
  final GetRequestQuotationReportLocationsByWarehouse getLocationsByWarehouse;
  final GetRequestQuotationReportExportPdfUrl getExportPdfUrl;
  final GetRequestQuotationReportExportExcelUrl getExportExcelUrl;

  RequestQuotationReportController({
    required this.getRequestQuotationReportList,
    required this.getRequestQuotationReportFormOptions,
    required this.getLocationsByWarehouse,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
  });

  List<RequestQuotationReportModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;
  RequestQuotationReportSummary? _summary;
  bool _hasFetchedOnce = false;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  static const int _perPage = 15;

  String _searchQuery = '';
  int? _selectedVendorId;
  int? _selectedWarehouseId;
  int? _selectedLocationId;
  String? _selectedStatus;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  List<RequestQuotationVendorOption> _vendorOptions = [];
  List<RequestQuotationWarehouseOption> _warehouseOptions = [];
  List<RequestQuotationLocationOption> _locationOptions = [];
  List<String> _statusOptions = [];

  bool _isLoadingOptions = false;
  bool _isLoadingLocations = false;
  String? _optionsError;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  List<RequestQuotationReportModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  RequestQuotationReportSummary? get summary => _summary;
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
  String? get selectedStatus => _selectedStatus;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;

  List<RequestQuotationVendorOption> get vendorOptions => _vendorOptions;
  List<RequestQuotationWarehouseOption> get warehouseOptions => _warehouseOptions;
  List<RequestQuotationLocationOption> get locationOptions => _locationOptions;
  List<String> get statusOptions => _statusOptions;

  bool get isLoadingOptions => _isLoadingOptions;
  bool get isLoadingLocations => _isLoadingLocations;
  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      _searchQuery.isNotEmpty ||
      _selectedVendorId != null ||
      _selectedWarehouseId != null ||
      _selectedLocationId != null ||
      (_selectedStatus != null && _selectedStatus!.isNotEmpty) ||
      _dateFrom != null ||
      _dateTo != null;

  bool get canExport => _list.isNotEmpty;
  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

  String? _formatDate(DateTime? d) => d == null
      ? null
      : '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  Future<void> fetchFormOptions() async {
    if (_isLoadingOptions) return;

    _isLoadingOptions = true;
    _optionsError = null;
    notifyListeners();

    try {
      final options = await getRequestQuotationReportFormOptions();

      _warehouseOptions = options.warehouses;
      _vendorOptions = options.vendors;
      _statusOptions = options.statuses;
    } catch (e) {
      _optionsError = _extractMessage(e);
      _warehouseOptions = [];
      _vendorOptions = [];
      _statusOptions = [];
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
      final result = await getRequestQuotationReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        idVendor: _selectedVendorId,
        idWarehouse: _selectedWarehouseId,
        idLocation: _selectedLocationId,
        status: _selectedStatus,
        dateFrom: _formatDate(_dateFrom),
        dateTo: _formatDate(_dateTo),
      );

      final meta = result['meta'] as RequestQuotationReportPaginationMeta;

      _list = result['items'] as List<RequestQuotationReportModel>;
      _summary = result['summary'] as RequestQuotationReportSummary;
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

  void selectStatus(String? status) {
    _selectedStatus = (status == null || status.isEmpty) ? null : status;
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
    _selectedStatus = null;
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

    final ExportUrlInfo info = type == 'pdf'
        ? getExportPdfUrl(
            dateFrom: _formatDate(_dateFrom),
            dateTo: _formatDate(_dateTo),
            idVendor: _selectedVendorId,
            idWarehouse: _selectedWarehouseId,
            idLocation: _selectedLocationId,
            status: _selectedStatus,
          )
        : getExportExcelUrl(
            dateFrom: _formatDate(_dateFrom),
            dateTo: _formatDate(_dateTo),
            idVendor: _selectedVendorId,
            idWarehouse: _selectedWarehouseId,
            idLocation: _selectedLocationId,
            status: _selectedStatus,
          );

    final ext = type == 'pdf' ? 'pdf' : 'xlsx';

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    _currentTaskId = await DownloadService.instance.download(
      url: info.url,
      headers: info.headers,
      fileName: 'rfq_report_${DateTime.now().millisecondsSinceEpoch}.$ext',
      label: 'RFQ Report ${type.toUpperCase()}',
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