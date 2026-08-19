import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/domain/usecases/stock_count_usecases.dart';

class StockCountController extends ChangeNotifier {
  final GetSCList getList;
  final GetSCDetail getDetail;
  final GetSCFormOptions getFormOptions;
  final CreateStockCount createSC;
  final UpdateStockCountHeader updateHeader;
  final ConfirmStockCount confirmSC;
  final ValidateStockCount validateSC;
  final CancelStockCount cancelSC;
  final DeleteStockCount deleteSC;
  final StoreLocationCount storeLocationCount;
  final LoadSCProducts loadProducts;
  final GetSCLocationsByWarehouse getLocationsByWarehouse;
  final GetSCIndexLocation getIndexLocation;
  final GetSCSteps getSteps;
  final ApproveStockCount approveSC;
  final RejectStockCount rejectSC;

  StockCountController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.createSC,
    required this.updateHeader,
    required this.confirmSC,
    required this.validateSC,
    required this.cancelSC,
    required this.deleteSC,
    required this.storeLocationCount,
    required this.loadProducts,
    required this.getLocationsByWarehouse,
    required this.getIndexLocation,
    required this.getSteps,
    required this.approveSC,
    required this.rejectSC,
  });

  static const int _perPage = 15;

  List<StockCountModel> _all = [];
  List<StockCountModel> _filtered = []; 
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';             
  String? _statusFilter;

  StockCountDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  StockCountFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  List<StockCountModel> get pageItems {
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

  StockCountDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  StockCountFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Map<String, dynamic>? get approvalSteps => _approvalSteps;
  bool get isLoadingSteps => _isLoadingSteps;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <StockCountModel>[];
      int p = 1;
      while (true) {
        final r = await getList(page: p, perPage: 100, status: _statusFilter);
        final meta = r['meta'] as StockCountPaginationMeta;
        all.addAll(r['items'] as List<StockCountModel>);
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
      return (t.warehouseName?.toLowerCase().contains(q) ?? false) ||
          (t.locationNames?.toLowerCase().contains(q) ?? false);
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

  Future<bool> create({
    required int idWarehouse,
    int? idLocation,
    required String selectBy,
    String? note,
  }) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await createSC(idWarehouse: idWarehouse, idLocation: idLocation, selectBy: selectBy, note: note);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Stock Count created';
      await fetchList(status: _statusFilter);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveHeader({
    required int idStockOpname,
    required int idWarehouse,
    int? idLocation,
    required String selectBy,
    String? note,
    required String originalStatus,
  }) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await updateHeader(
        idStockOpname: idStockOpname,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        selectBy: selectBy,
        note: note,
        originalStatus: originalStatus,
      );
      _successMessage = result['message']?.toString() ?? 'Saved';
      await fetchList(status: _statusFilter);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> confirmHeader({
    required int idStockOpname,
    required int idWarehouse,
    int? idLocation,
    required String selectBy,
    String? note,
  }) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await confirmSC(
        idStockOpname: idStockOpname,
        idWarehouse: idWarehouse,
        idLocation: idLocation,
        selectBy: selectBy,
        note: note,
      );
      _successMessage = result['message']?.toString() ?? 'Confirmed';
      await fetchList(status: _statusFilter);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> validate({required int idStockOpname, required int idWarehouse}) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await validateSC(idStockOpname: idStockOpname, idWarehouse: idWarehouse);
      _successMessage = result['message']?.toString() ?? 'Validated';
      await fetchList(status: _statusFilter);
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
      await cancelSC(encryption, reason);
      _successMessage = 'Stock Count cancelled';
      await fetchList(status: _statusFilter);
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
      await deleteSC(id);
      _successMessage = 'Stock Count deleted';
      await fetchList(status: _statusFilter);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveLocationCount({
    required int idStockOpname,
    required int idLocation,
    required List<SCFormItem> products,
    required String actionType,
  }) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await storeLocationCount(
        idStockOpname: idStockOpname,
        idLocation: idLocation,
        products: products,
        actionType: actionType,
      );
      _successMessage = result['message']?.toString() ?? 'Saved';
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

  Future<bool> approve(int id) async {
    _isSaving = true;
    notifyListeners();
    try {
      await approveSC(id);
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
    notifyListeners();
    try {
      await rejectSC(id);
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
    _detail = null;
    _detailError = null;
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}