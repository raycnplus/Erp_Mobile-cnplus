import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/data/models/service_invoice_report_models.dart';
import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/domain/usecases/service_invoice_report_usecases.dart';

class ServiceInvoiceReportController extends ChangeNotifier {
  final GetServiceInvoiceReportList getServiceInvoiceReportList;
  final GetServiceInvoiceReportFormOptions getServiceInvoiceReportFormOptions;

  ServiceInvoiceReportController({
    required this.getServiceInvoiceReportList,
    required this.getServiceInvoiceReportFormOptions,
  });

  List<ServiceInvoiceReportModel> _list = [];
  bool _isLoadingList = false;
  String? _listError;
  ServiceInvoiceReportSummary? _summary;

  // True setelah user melakukan search/apply filter pertama kali (konsisten
  // dengan semua fitur report lainnya: list TIDAK auto-load saat screen
  // dibuka, minimal harus search atau apply filter dulu).
  bool _hasFetchedOnce = false;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;

  String _searchQuery = '';
  int? _selectedCustomerId;
  int? _selectedSalesPersonId;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _selectedStatus;

  List<ServiceInvoiceCustomerOption> _customerOptions = [];
  List<ServiceInvoiceSalesPersonOption> _salesPersonOptions = [];
  List<String> _statuses = [];
  bool _isLoadingOptions = false;
  String? _optionsError;

  List<ServiceInvoiceReportModel> get list => _list;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  ServiceInvoiceReportSummary? get summary => _summary;
  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;

  int? get selectedCustomerId => _selectedCustomerId;
  int? get selectedSalesPersonId => _selectedSalesPersonId;
  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String? get selectedStatus => _selectedStatus;

  List<ServiceInvoiceCustomerOption> get customerOptions => _customerOptions;
  List<ServiceInvoiceSalesPersonOption> get salesPersonOptions => _salesPersonOptions;
  List<String> get statuses => _statuses;
  bool get isLoadingOptions => _isLoadingOptions;
  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      _selectedCustomerId != null ||
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
      final options = await getServiceInvoiceReportFormOptions();
      _customerOptions = options['customers'] as List<ServiceInvoiceCustomerOption>;
      _salesPersonOptions = options['salespersons'] as List<ServiceInvoiceSalesPersonOption>;
      _statuses = options['statuses'] as List<String>;
    } catch (e) {
      _optionsError = e.toString();
      _customerOptions = [];
      _salesPersonOptions = [];
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
      final result = await getServiceInvoiceReportList(
        page: page ?? _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        customerId: _selectedCustomerId,
        salesId: _selectedSalesPersonId,
        dateFrom: _dateFrom != null ? _formatDate(_dateFrom!) : null,
        dateTo: _dateTo != null ? _formatDate(_dateTo!) : null,
        status: _selectedStatus,
      );
      final meta = result['meta'] as ServiceInvoiceReportPaginationMeta;
      _list = result['items'] as List<ServiceInvoiceReportModel>;
      _summary = result['summary'] as ServiceInvoiceReportSummary;
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

  void selectCustomer(int? idCustomer) {
    _selectedCustomerId = idCustomer;
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
    _selectedCustomerId = null;
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