import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/models/scrap_order_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/domain/usecases/scrap_order_usecases.dart';

class ScrapOrderController extends ChangeNotifier {
  final GetScrapOrderList getList;
  final GetScrapOrderDetail getDetail;
  final GetScrapOrderFormOptions getFormOptions;
  final SaveScrapOrder saveSO;
  final ConfirmScrapOrder confirmSO;
  final ValidateScrapOrder validateSO;
  final CancelScrapOrder cancelSO;
  final DeleteScrapOrder deleteSO;
  final GetScrapOrderProductsByLocation getProductsByLocation;
  final CheckScrapOrderStock checkStockUC;
  final GetScrapOrderSteps getSteps;
  final ApproveScrapOrder approveSO;
  final RejectScrapOrder rejectSO;

  ScrapOrderController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveSO,
    required this.confirmSO,
    required this.validateSO,
    required this.cancelSO,
    required this.deleteSO,
    required this.getProductsByLocation,
    required this.checkStockUC,
    required this.getSteps,
    required this.approveSO,
    required this.rejectSO,
  });

  static const int _perPage = 15;

  List<ScrapOrderModel> _all = [];
  List<ScrapOrderModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  ScrapOrderDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ScrapOrderFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  bool _isLoadingProducts = false;
  List<Map<String, dynamic>> _locationProducts = [];

  List<ScrapOrderModel> get pageItems {
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

  ScrapOrderDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  ScrapOrderFormOptions? get formOptions => _formOptions;
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
      final all = <ScrapOrderModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as ScrapOrderPaginationMeta;
        all.addAll(r['items'] as List<ScrapOrderModel>);
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
      return (t.documentCode?.toLowerCase().contains(q) ?? false) ||
          (t.locationName?.toLowerCase().contains(q) ?? false) ||
          (t.scrapReason?.toLowerCase().contains(q) ?? false);
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

  Future<List<Map<String, dynamic>>> fetchProductsByLocation(int locationId) async {
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

  Future<double> checkStock(int productId, int locationId) => checkStockUC(productId, locationId);

  Future<bool> save(ScrapOrderFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await saveSO(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ??
          (f.isEditMode ? 'Scrap Order updated' : 'Scrap Order created');
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

  Future<bool> confirm(ScrapOrderFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await confirmSO(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Scrap Order confirmed';
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

  Future<bool> validate(ScrapOrderFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await validateSO(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Scrap Order validated';
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

  Future<bool> cancel(String encryption, String reason) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await cancelSO(encryption, reason);
      _successMessage = 'Scrap Order cancelled';
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
      _successMessage = 'Scrap Order deleted';
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