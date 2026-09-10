import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/models/return_dn_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/domain/usecases/return_dn_usecases.dart';

class ReturnDNController extends ChangeNotifier {
  final GetRDNList getList;
  final GetRDNDetail getDetail;
  final GetRDNFormOptions getFormOptions;
  final GetValidatedDNs getValidatedDNsUC;
  final GetDNBySO getDNBySOUC;
  final GetItemsByDN getItemsByDNUC;
  final GetReplaceProducts getReplaceProductsUC;
  final GetReplaceProductStock getReplaceProductStockUC;
  final SaveReturnDN saveRDN;
  final ConfirmReturnDN confirmRDN;
  final ValidateReturnDN validateRDN;
  final CancelReturnDN cancelRDN;
  final DeleteReturnDN deleteRDN;
  final SaveRDNTracking saveTrackingUC;
  final GetRDNSteps getSteps;
  final ApproveReturnDN approveRDN;
  final RejectReturnDN rejectRDN;

  ReturnDNController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.getValidatedDNsUC,
    required this.getDNBySOUC,
    required this.getItemsByDNUC,
    required this.getReplaceProductsUC,
    required this.getReplaceProductStockUC,
    required this.saveRDN,
    required this.confirmRDN,
    required this.validateRDN,
    required this.cancelRDN,
    required this.deleteRDN,
    required this.saveTrackingUC,
    required this.getSteps,
    required this.approveRDN,
    required this.rejectRDN,
  });

  static const int _perPage = 15;

  List<ReturnDNModel> _all = [];
  List<ReturnDNModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  ReturnDNDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ReturnDNFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  List<ReturnDNModel> get pageItems {
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

  ReturnDNDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  ReturnDNFormOptions? get formOptions => _formOptions;
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
      final all = <ReturnDNModel>[];
      int p = 1;
      while (true) {
        final r = await getList(page: p, perPage: 100, status: _statusFilter, search: _searchQuery.isEmpty ? null : _searchQuery);
        final meta = r['meta'] as ReturnDNPaginationMeta;
        all.addAll(r['items'] as List<ReturnDNModel>);
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
    _filtered = _all.where((t) =>
        (t.documentCode?.toLowerCase().contains(q) ?? false) ||
        (t.resolvedReference?.toLowerCase().contains(q) ?? false) ||
        (t.soReference?.toLowerCase().contains(q) ?? false)).toList();
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

  Future<List<DNOption>> getValidatedDNs({int? excludeReturnDeliveryNoteId}) =>
      getValidatedDNsUC(excludeReturnDeliveryNoteId: excludeReturnDeliveryNoteId);

  Future<List<DNOption>> getDNBySO(int soId) => getDNBySOUC(soId);

  Future<List<ReturnDNItem>> getItemsByDN(List<int> dnIds) => getItemsByDNUC(dnIds);

  Future<ReplaceProductsResult> getReplaceProducts(int idDeliveryNote) => getReplaceProductsUC(idDeliveryNote);

  Future<double> getReplaceProductStock({required int idProduct, required int idDeliveryNote}) =>
      getReplaceProductStockUC(idProduct: idProduct, idDeliveryNote: idDeliveryNote);

  Future<bool> save(ReturnDNFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveRDN(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? (f.isEditMode ? 'Return DN updated' : 'Return DN created');
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

  Future<bool> confirm(ReturnDNFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await confirmRDN(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Return DN confirmed';
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

  Future<bool> validate(ReturnDNFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await validateRDN(f);
      _successMessage = result['message']?.toString() ?? 'Return DN validated';
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
      await cancelRDN(encryption, reason);
      _successMessage = 'Return DN cancelled';
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
      await deleteRDN(id);
      _successMessage = 'Return DN deleted';
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

  Future<bool> saveTracking({required int idReturnDeliveryNoteItem, List<Map<String, dynamic>>? trackingData}) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      final result = await saveTrackingUC(idReturnDeliveryNoteItem: idReturnDeliveryNoteItem, trackingData: trackingData);
      _successMessage = result['message']?.toString() ?? 'Tracking saved';
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
    notifyListeners();
    try {
      await approveRDN(id);
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
    notifyListeners();
    try {
      await rejectRDN(id);
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