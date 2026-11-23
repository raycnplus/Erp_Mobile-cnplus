import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/models/sales_order_report_models.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/domain/usecases/sales_order_report_usecases.dart';

class SalesOrderReportController extends ChangeNotifier {
  final GetSalesOrderReportList getSalesOrderReportList;
  final GetSalesOrderReportFormOptions getSalesOrderReportFormOptions;
  final GetSalesOrderReportLocationsByWarehouse getLocationsByWarehouse;
  final GetSalesOrderReportExportPdfUrl getExportPdfUrl;
  final GetSalesOrderReportExportExcelUrl getExportExcelUrl;
  final GetSalesOrderReportExportDetailPdfUrl getExportDetailPdfUrl;
  final GetSalesOrderReportExportDetailExcelUrl getExportDetailExcelUrl;

  SalesOrderReportController({
    required this.getSalesOrderReportList,
    required this.getSalesOrderReportFormOptions,
    required this.getLocationsByWarehouse,
    required this.getExportPdfUrl,
    required this.getExportExcelUrl,
    required this.getExportDetailPdfUrl,
    required this.getExportDetailExcelUrl,
  });

  List<SalesOrderReportModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;
  SalesOrderReportSummary? _summary;

  bool _hasFetchedOnce = false;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;

  String _searchQuery = '';
  int? _selectedWarehouseId;
  int? _selectedLocationId;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _selectedStatus;

  List<SalesOrderWarehouseOption> _warehouseOptions = [];
  List<String> _statuses = [];
  List<SalesOrderLocationOption> _locationOptions = [];
  bool _isLoadingOptions = false;
  bool _isLoadingLocations = false;
  String? _optionsError;

  bool _isExporting = false;
  int _downloadProgress = 0;
  String? _currentTaskId;
  String? _statusMessage;

  List<SalesOrderReportModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  SalesOrderReportSummary? get summary => _summary;
  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  int? get selectedWarehouseId => _selectedWarehouseId;
  int? get selectedLocationId => _selectedLocationId;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String? get selectedStatus => _selectedStatus;

  List<SalesOrderWarehouseOption> get warehouseOptions => _warehouseOptions;
  List<String> get statuses => _statuses;
  List<SalesOrderLocationOption> get locationOptions => _locationOptions;
  bool get isLoadingOptions => _isLoadingOptions;
  bool get isLoadingLocations => _isLoadingLocations;
  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      _selectedWarehouseId != null ||
      _selectedLocationId != null ||
      _dateFrom != null ||
      _dateTo != null ||
      _selectedStatus != null;

  bool get canExport => _hasFetchedOnce && _list.isNotEmpty;
  bool get isExporting => _isExporting;
  int get downloadProgress => _downloadProgress;

  String? consumeStatusMessage() {
    final msg = _statusMessage;
    _statusMessage = null;
    return msg;
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> fetchFormOptions() async {
    _isLoadingOptions = true;
    _optionsError = null;
    notifyListeners();
    try {
      final options = await getSalesOrderReportFormOptions();
      _warehouseOptions = options['warehouses'] as List<SalesOrderWarehouseOption>;
      _statuses = options['statuses'] as List<String>;
    } catch (e) {
      _optionsError = e.toString();
      _warehouseOptions = [];
      _statuses = [];
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchList({int? page}) async {
    _isLoadingList = true;
    _listError = null;
    _hasFetchedOnce = true;
    notifyListeners();
    try {
      final result = await getSalesOrderReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        idWarehouse: _selectedWarehouseId,
        idLocation: _selectedLocationId,
        dateFrom: _dateFrom != null ? _formatDate(_dateFrom!) : null,
        dateTo: _dateTo != null ? _formatDate(_dateTo!) : null,
        status: _selectedStatus,
      );
      final meta = result['meta'] as SalesOrderReportPaginationMeta;
      _list = result['items'] as List<SalesOrderReportModel>;
      _summary = result['summary'] as SalesOrderReportSummary;
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

  void selectStatus(String? status) {
    _selectedStatus = status;
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
    _selectedStatus = null;
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

    final SalesOrderReportExportUrlInfo info = type == 'pdf'
        ? getExportPdfUrl(
            idWarehouse: _selectedWarehouseId,
            idLocation: _selectedLocationId,
            dateFrom: from,
            dateTo: to,
            status: _selectedStatus,
          )
        : getExportExcelUrl(
            idWarehouse: _selectedWarehouseId,
            idLocation: _selectedLocationId,
            dateFrom: from,
            dateTo: to,
            status: _selectedStatus,
          );

    await _startDownload(
      info: info,
      type: type,
      fileNamePrefix: 'sales_order_report',
      label: 'Sales Order Report ${type.toUpperCase()}',
    );
  }

  Future<void> startExportDetail({
    required String encryption,
    required String reference,
    required String type,
  }) async {
    if (_isExporting || encryption.isEmpty) return;

    final SalesOrderReportExportUrlInfo info = type == 'pdf'
        ? getExportDetailPdfUrl(encryption)
        : getExportDetailExcelUrl(encryption);

    final safeRef = reference.replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_');

    await _startDownload(
      info: info,
      type: type,
      fileNamePrefix: 'sales_order_$safeRef',
      label: '$reference ${type.toUpperCase()}',
    );
  }

  Future<void> _startDownload({
    required SalesOrderReportExportUrlInfo info,
    required String type,
    required String fileNamePrefix,
    required String label,
  }) async {
    final ext = type == 'pdf' ? 'pdf' : 'xlsx';

    _isExporting = true;
    _downloadProgress = 0;
    notifyListeners();

    _currentTaskId = await DownloadService.instance.download(
      url: info.url,
      headers: info.headers,
      fileName: '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}.$ext',
      label: label,
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