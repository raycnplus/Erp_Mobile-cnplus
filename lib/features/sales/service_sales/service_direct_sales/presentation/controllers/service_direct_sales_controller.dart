import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/models/service_direct_sales_models.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/domain/usecases/service_direct_sales_usecases.dart';

class ServiceDirectSalesController extends ChangeNotifier {
  final GetSDSList                getList;
  final GetSDSDetail              getDetail;
  final GetSDSFormOptions         getFormOptions;
  final SaveServiceDirectSales    saveSDS;
  final CancelServiceDirectSales  cancelSDS;
  final DeleteServiceDirectSales  deleteSDS;
  final CreateInvoiceFromSDSTerm  createInvoiceFromTermUC;
  final GetSDSPriceFromList       getPriceFromList;

  ServiceDirectSalesController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveSDS,
    required this.cancelSDS,
    required this.deleteSDS,
    required this.createInvoiceFromTermUC,
    required this.getPriceFromList,
  });

  List<ServiceDirectSalesModel> _all      = [];
  List<ServiceDirectSalesModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage           = 1;
  static const int _perPage  = 15;
  String _searchQuery        = '';
  String? _statusFilter;

  ServiceDirectSalesDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ServiceDirectSalesFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded    = false;
  bool _isSaving         = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<ServiceDirectSalesModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  bool get isLoadingList     => _isLoadingList;
  String? get listError      => _listError;
  int get currentPage        => _currentPage;
  int get lastPage           => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total              => _filtered.length;
  bool get hasPrev           => _currentPage > 1;
  bool get hasNext           => _currentPage < lastPage;
  ServiceDirectSalesDetailModel? get detail => _detail;
  bool get isLoadingDetail   => _isLoadingDetail;
  String? get detailError    => _detailError;
  ServiceDirectSalesFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions  => _isLoadingOptions;
  bool get isSaving          => _isSaving;
  String? get formError      => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Future<void> fetchList({String? status}) async {
    _statusFilter  = status;
    _isLoadingList = true;
    _listError     = null;
    notifyListeners();
    try {
      final all = <ServiceDirectSalesModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page:    p,
          perPage: 100,
          status:  _statusFilter,
          search:  _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as ServiceDirectSalesPaginationMeta;
        all.addAll(r['items'] as List<ServiceDirectSalesModel>);
        if (p >= meta.lastPage) break;
        p++;
      }
      _all = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _msg(e);
      _all       = [];
      _filtered  = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_all);
      return;
    }
    final q = _searchQuery.toLowerCase();
    _filtered = _all.where((t) =>
        (t.reference?.toLowerCase().contains(q) ?? false) ||
        (t.customerName?.toLowerCase().contains(q) ?? false)).toList();
  }

  void search(String q) {
    _searchQuery = q.trim();
    _currentPage = 1;
    _applyFilter();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _currentPage = 1;
    _applyFilter();
    notifyListeners();
  }

  void goToPage(int p) {
    if (p < 1 || p > lastPage) return;
    _currentPage = p;
    notifyListeners();
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true;
    _detailError     = null;
    notifyListeners();
    try {
      _detail = await getDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail      = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_optionsLoaded && !forceRefresh) return;
    _isLoadingOptions = true;
    notifyListeners();
    try {
      _formOptions   = await getFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<double?> fetchPriceFromList(int serviceId, int priceListId) =>
      getPriceFromList(serviceId, priceListId);

  Future<bool> save(ServiceDirectSalesFormModel f, {String status = 'save'}) async {
    _isSaving       = true;
    _formError      = null;
    _successMessage = null;
    notifyListeners();
    try {
      final taxRate    = _formOptions?.defaultTaxRate ?? 11.0;
      _savedEncryption = await saveSDS(f, status, defaultTaxRate: taxRate);
      _successMessage  = switch (status) {
        'confirm'  => 'Service Direct Sales confirmed',
        'validate' => 'Service Direct Sales validated and Invoice created',
        _          => f.isEditMode ? 'Service Direct Sales updated' : 'Service Direct Sales created',
      };
      await fetchList(status: _statusFilter);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> cancel(int id, String reason) async {
    _isSaving  = true;
    _formError = null;
    notifyListeners();
    try {
      await cancelSDS(id, reason);
      _successMessage = 'Service Direct Sales cancelled';
      await fetchList(status: _statusFilter);
      if (_detail != null) await fetchDetail(_detail!.encryption);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> remove(int id) async {
    _isSaving  = true;
    _formError = null;
    notifyListeners();
    try {
      await deleteSDS(id);
      _successMessage = 'Service Direct Sales deleted';
      await fetchList(status: _statusFilter);
      if (pageItems.isEmpty && _currentPage > 1) _currentPage--;
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> createInvoiceFromSchedule(int sdsId, int scheduleId) async {
    _isSaving  = true;
    _formError = null;
    notifyListeners();
    try {
      final result    = await createInvoiceFromTermUC(sdsId, scheduleId);
      _successMessage = result['message']?.toString() ?? 'Invoice created';
      if (_detail != null) await fetchDetail(_detail!.encryption);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _detail          = null;
    _detailError     = null;
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}