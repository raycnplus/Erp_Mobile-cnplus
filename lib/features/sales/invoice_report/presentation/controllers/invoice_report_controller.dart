import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/data/models/invoice_report_models.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/domain/usecases/invoice_report_usecases.dart';

class InvoiceReportController extends ChangeNotifier {
  final GetInvoiceReportList getInvoiceReportList;
  final GetInvoiceReportFormOptions getInvoiceReportFormOptions;

  InvoiceReportController({
    required this.getInvoiceReportList,
    required this.getInvoiceReportFormOptions,
  });

  List<InvoiceReportModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;
  InvoiceReportSummary? _summary;

  // True setelah user melakukan search/apply filter pertama kali (konsisten
  // dengan Quotation, Sales Order & Direct Sales Report: list TIDAK auto-load
  // saat screen dibuka, minimal harus search atau apply filter dulu).
  bool _hasFetchedOnce = false;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;

  String _searchQuery = '';
  String? _selectedSourceType;
  int? _selectedSalesPersonId;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _selectedStatus;

  List<InvoiceSalesPersonOption> _salesPersonOptions = [];
  List<String> _statuses = [];
  List<InvoiceSourceTypeOption> _sourceTypeOptions = [];
  bool _isLoadingOptions = false;
  String? _optionsError;

  List<InvoiceReportModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  InvoiceReportSummary? get summary => _summary;
  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  String? get selectedSourceType => _selectedSourceType;
  int? get selectedSalesPersonId => _selectedSalesPersonId;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String? get selectedStatus => _selectedStatus;

  List<InvoiceSalesPersonOption> get salesPersonOptions => _salesPersonOptions;
  List<String> get statuses => _statuses;
  List<InvoiceSourceTypeOption> get sourceTypeOptions => _sourceTypeOptions;
  bool get isLoadingOptions => _isLoadingOptions;
  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      (_selectedSourceType != null && _selectedSourceType!.isNotEmpty) ||
      _selectedSalesPersonId != null ||
      _dateFrom != null ||
      _dateTo != null ||
      _selectedStatus != null;

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> fetchFormOptions() async {
    _isLoadingOptions = true;
    _optionsError = null;
    notifyListeners();
    try {
      final options = await getInvoiceReportFormOptions();
      _salesPersonOptions = options['salespersons'] as List<InvoiceSalesPersonOption>;
      _statuses = options['statuses'] as List<String>;
      _sourceTypeOptions = options['sourceTypes'] as List<InvoiceSourceTypeOption>;
    } catch (e) {
      _optionsError = e.toString();
      _salesPersonOptions = [];
      _statuses = [];
      _sourceTypeOptions = [];
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
      final result = await getInvoiceReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        sourceType: _selectedSourceType,
        salesPerson: _selectedSalesPersonId,
        dateFrom: _dateFrom != null ? _formatDate(_dateFrom!) : null,
        dateTo: _dateTo != null ? _formatDate(_dateTo!) : null,
        status: _selectedStatus,
      );
      final meta = result['meta'] as InvoiceReportPaginationMeta;
      _list = result['items'] as List<InvoiceReportModel>;
      _summary = result['summary'] as InvoiceReportSummary;
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

  void selectSourceType(String? sourceType) {
    _selectedSourceType = sourceType;
    notifyListeners();
  }

  void selectSalesPerson(int? idUser) {
    _selectedSalesPersonId = idUser;
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
    _selectedSourceType = null;
    _selectedSalesPersonId = null;
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

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}