import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/models/purchase_request_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/domain/usecases/purchase_request_usecases.dart';

class PurchaseRequestController extends ChangeNotifier {
  final GetPRList getList;
  final GetPRDetail getDetail;
  final GetPRFormOptions getFormOptions;
  final SavePurchaseRequest savePR;
  final CancelPurchaseRequest cancelPR;
  final DeletePurchaseRequest deletePR;
  final CreateRfqFromPR createRfqUC;
  final CreateDpFromPR createDpUC;
  final ApprovePurchaseRequest approvePR;
  final RejectPurchaseRequest rejectPR;
  final GetPRSteps getSteps;

  PurchaseRequestController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.savePR,
    required this.cancelPR,
    required this.deletePR,
    required this.createRfqUC,
    required this.createDpUC,
    required this.approvePR,
    required this.rejectPR,
    required this.getSteps,
  });

  List<PurchaseRequestModel> _all = [];
  List<PurchaseRequestModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';
  String? _statusFilter;

  PurchaseRequestDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  PurchaseRequestFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  List<PurchaseRequestModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) {
      return [];
    }
    return _filtered.sublist(s, e);
  }

  bool get isLoadingList {
    return _isLoadingList;
  }

  String? get listError {
    return _listError;
  }

  int get currentPage {
    return _currentPage;
  }

  int get lastPage {
    return (_filtered.length / _perPage).ceil().clamp(1, 99999);
  }

  int get total {
    return _filtered.length;
  }

  bool get hasPrev {
    return _currentPage > 1;
  }

  bool get hasNext {
    return _currentPage < lastPage;
  }

  PurchaseRequestDetailModel? get detail {
    return _detail;
  }

  bool get isLoadingDetail {
    return _isLoadingDetail;
  }

  String? get detailError {
    return _detailError;
  }

  PurchaseRequestFormOptions? get formOptions {
    return _formOptions;
  }

  bool get isLoadingOptions {
    return _isLoadingOptions;
  }

  bool get isSaving {
    return _isSaving;
  }

  String? get formError {
    return _formError;
  }

  String? get successMessage {
    return _successMessage;
  }

  String? get savedEncryption {
    return _savedEncryption;
  }

  Map<String, dynamic>? get approvalSteps {
    return _approvalSteps;
  }

  bool get isLoadingSteps {
    return _isLoadingSteps;
  }

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <PurchaseRequestModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as PurchaseRequestPaginationMeta;
        all.addAll(r['items'] as List<PurchaseRequestModel>);
        if (p >= meta.lastPage) {
          break;
        }
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
          (t.requestedByName?.toLowerCase().contains(q) ?? false) ||
          (t.warehouseName?.toLowerCase().contains(q) ?? false) ||
          (t.locationName?.toLowerCase().contains(q) ?? false);
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
    if (p < 1 || p > lastPage) {
      return;
    }
    _currentPage = p;
    notifyListeners();
  }

  void nextPage() {
    goToPage(_currentPage + 1);
  }

  void prevPage() {
    goToPage(_currentPage - 1);
  }

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
    if (_optionsLoaded && !forceRefresh) {
      return;
    }
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

  Future<bool> save(PurchaseRequestFormModel f, {String status = 'save'}) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      _savedEncryption = await savePR(f, status);
      _successMessage = switch (status) {
        'submit' => 'Purchase Request submitted for approval',
        _ => f.isEditMode ? 'Purchase Request updated' : 'Purchase Request created',
      };
      await fetchList(status: _statusFilter);
      if (_savedEncryption?.isNotEmpty == true) {
        await fetchDetail(_savedEncryption!);
      }
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
      await cancelPR(id, reason);
      _successMessage = 'Purchase Request cancelled';
      await fetchList(status: _statusFilter);
      if (_detail != null) {
        await fetchDetail(_detail!.encryption);
      }
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
      await deletePR(id);
      _successMessage = 'Purchase Request deleted';
      await fetchList(status: _statusFilter);
      if (pageItems.isEmpty && _currentPage > 1) {
        _currentPage--;
      }
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> createRfq(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      final result = await createRfqUC(id);
      _successMessage = result['message']?.toString() ?? 'RFQ created';
      if (_detail != null) {
        await fetchDetail(_detail!.encryption);
      }
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> createDp(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      final result = await createDpUC(id);
      _successMessage = result['message']?.toString() ?? 'Direct Purchase created';
      if (_detail != null) {
        await fetchDetail(_detail!.encryption);
      }
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
      await approvePR(id);
      _successMessage = 'Approved';
      if (_detail != null) {
        await fetchDetail(_detail!.encryption);
      }
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
      await rejectPR(id);
      _successMessage = 'Rejected';
      if (_detail != null) {
        await fetchDetail(_detail!.encryption);
      }
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

  String _msg(dynamic e) {
    return e.toString().replaceFirst('Exception:', '').trim();
  }
}