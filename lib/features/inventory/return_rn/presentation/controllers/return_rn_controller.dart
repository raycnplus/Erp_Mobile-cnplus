import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/models/return_rn_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/domain/usecases/return_rn_usecases.dart';

class ReturnRNController extends ChangeNotifier {
  final GetRRNList getList;
  final GetRRNDetail getDetail;
  final GetRRNFormOptions getFormOptions;
  final GetValidatedRNs getValidatedRNsUC;
  final GetItemsByRN getItemsByRNUC;
  final SaveReturnRN saveRRN;
  final ConfirmReturnRN confirmRRN;
  final ValidateReturnRN validateRRN;
  final CancelReturnRN cancelRRN;
  final DeleteReturnRN deleteRRN;
  final SaveRRNTracking saveTrackingUC;
  final GetRRNLotSerialsSorted getLotSerialsSortedUC;
  final GetRRNSteps getSteps;
  final ApproveReturnRN approveRRN;
  final RejectReturnRN rejectRRN;

  ReturnRNController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.getValidatedRNsUC,
    required this.getItemsByRNUC,
    required this.saveRRN,
    required this.confirmRRN,
    required this.validateRRN,
    required this.cancelRRN,
    required this.deleteRRN,
    required this.saveTrackingUC,
    required this.getLotSerialsSortedUC,
    required this.getSteps,
    required this.approveRRN,
    required this.rejectRRN,
  });

  static const int _perPage = 15;

  List<ReturnRNModel> _all = [];
  List<ReturnRNModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  ReturnRNDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ReturnRNFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  List<ReturnRNModel> get pageItems {
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

  ReturnRNDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  ReturnRNFormOptions? get formOptions => _formOptions;
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
      final all = <ReturnRNModel>[];
      int p = 1;
      while (true) {
        final r = await getList(page: p, perPage: 100, status: _statusFilter, search: _searchQuery.isEmpty ? null : _searchQuery);
        final meta = r['meta'] as ReturnRNPaginationMeta;
        all.addAll(r['items'] as List<ReturnRNModel>);
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
        (t.poReference?.toLowerCase().contains(q) ?? false)).toList();
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

  Future<List<ValidatedRNOption>> getValidatedRNs() => getValidatedRNsUC();

  Future<List<RNSourceItem>> getItemsByRN(List<int> idsReceiptNote) => getItemsByRNUC(idsReceiptNote);

  Future<bool> save(ReturnRNFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveRRN(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? (f.isEditMode ? 'Return RN updated' : 'Return RN created');
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

  Future<bool> confirm(ReturnRNFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await confirmRRN(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Return RN confirmed';
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

  Future<bool> validate(ReturnRNFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await validateRRN(f);
      _successMessage = result['message']?.toString() ?? 'Return RN validated';
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
      await cancelRRN(encryption, reason);
      _successMessage = 'Return RN cancelled';
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
      await deleteRRN(id);
      _successMessage = 'Return RN deleted';
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

  Future<bool> saveTracking({required int idReturnReceiptNoteItem, List<Map<String, dynamic>>? trackingData}) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      final result = await saveTrackingUC(idReturnReceiptNoteItem: idReturnReceiptNoteItem, trackingData: trackingData);
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

  Future<Map<String, dynamic>> lotSerialsSorted(int productId, int locationId) =>
      getLotSerialsSortedUC(productId, locationId);

  Future<bool> approve(int id) async {
    _isSaving = true;
    notifyListeners();
    try {
      await approveRRN(id);
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
      await rejectRRN(id);
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