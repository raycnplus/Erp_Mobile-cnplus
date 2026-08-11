import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/data/models/sales_order_models.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/domain/usecases/sales_order_usecases.dart';

class SalesOrderController extends ChangeNotifier {
  final GetSOList getList;
  final GetSODetail getDetail;
  final GetSOFormOptions getFormOptions;
  final SaveSalesOrder saveSO;
  final CancelSalesOrder cancelSO;
  final CloseSalesOrder closeSO;
  final DeleteSalesOrder deleteSO;
  final CreateInvoiceFromSO createInvoiceUC;
  final CreateInvoiceFromTerm createInvoiceFromTermUC;
  final GetSOProductsByLocation getProductsByLocation;
  final GetSOPriceFromList getPriceFromList;
  final ApproveSalesOrder approveSO;
  final RejectSalesOrder rejectSO;
  final GetSOSteps getSteps;

  SalesOrderController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveSO,
    required this.cancelSO,
    required this.closeSO,
    required this.deleteSO,
    required this.createInvoiceUC,
    required this.createInvoiceFromTermUC,
    required this.getProductsByLocation,
    required this.getPriceFromList,
    required this.approveSO,
    required this.rejectSO,
    required this.getSteps,
  });

  static const int _perPage = 15;

  List<SalesOrderModel> _all = [];
  List<SalesOrderModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  SalesOrderDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  SalesOrderFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  bool _isLoadingProducts = false;
  List<SOProductOption> _locationProducts = [];

  List<SalesOrderModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < lastPage;

  SalesOrderDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  SalesOrderFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Map<String, dynamic>? get approvalSteps => _approvalSteps;
  bool get isLoadingSteps => _isLoadingSteps;
  bool get isLoadingProducts => _isLoadingProducts;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <SalesOrderModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as SalesOrderPaginationMeta;
        all.addAll(r['items'] as List<SalesOrderModel>);
        if (p >= meta.lastPage) break;
        p++;
      }

      _all = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _msg(e);
      _all = [];
      _filtered = [];
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
    _filtered = _all.where((t) {
      return (t.reference?.toLowerCase().contains(q) ?? false) ||
          (t.customerName?.toLowerCase().contains(q) ?? false);
    }).toList();
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
    _detailError = null;
    notifyListeners();

    try {
      _detail = await getDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
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
      _formOptions = await getFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<List<SOProductOption>> fetchProductsByLocation(int locationId) async {
    _isLoadingProducts = true;
    notifyListeners();

    try {
      _locationProducts = await getProductsByLocation(locationId);
      return _locationProducts;
    } catch (_) {
      return [];
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<double?> fetchPriceFromList(int productId, int priceListId) =>
      getPriceFromList(productId, priceListId);

  Future<bool> save(SalesOrderFormModel f, {String status = 'save'}) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final taxRate = _formOptions?.defaultTaxRate ?? 11.0;
      _savedEncryption = await saveSO(f, status, defaultTaxRate: taxRate);
      _successMessage = switch (status) {
        'confirm' => 'Sales Order confirmed',
        'validate' => 'Sales Order validated',
        _ => f.isEditMode ? 'Sales Order updated' : 'Sales Order created',
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
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await cancelSO(id, reason);
      _successMessage = 'Sales Order cancelled';
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

  Future<bool> close(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await closeSO(id);
      _successMessage = 'Sales Order closed';
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
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await deleteSO(id);
      _successMessage = 'Sales Order deleted';
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

  Future<bool> createInvoice(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      final result = await createInvoiceUC(id);
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

  Future<bool> createInvoiceFromSchedule(int soId, int scheduleId) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      final result = await createInvoiceFromTermUC(soId, scheduleId);
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

  Future<bool> approve(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await approveSO(id);
      _successMessage = 'Approved';
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

  Future<bool> reject(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await rejectSO(id);
      _successMessage = 'Rejected';
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

  Future<void> loadSteps(int id) async {
    _isLoadingSteps = true;
    _approvalSteps = null;
    notifyListeners();

    try {
      _approvalSteps = await getSteps(id);
    } catch (_) {
      _approvalSteps = null;
    } finally {
      _isLoadingSteps = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}