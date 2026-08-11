import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/models/receipt_note_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/domain/usecases/receipt_note_usecases.dart';

class ReceiptNoteController extends ChangeNotifier {
  final GetRNList getList;
  final GetRNDetail getDetail;
  final GetRNFormOptions getFormOptions;
  final GetRNInventorySettings getInventorySettings;
  final SaveReceiptNote saveRN;
  final ConfirmReceiptNote confirmRN;
  final ValidateReceiptNote validateRN;
  final CancelReceiptNote cancelRN;
  final DeleteReceiptNote deleteRN;
  final SaveReceiptNoteTracking saveTrackingUC;
  final CreateReturnFromReceiptNote createReturnUC;
  final ApproveReceiptNote approveRN;
  final RejectReceiptNote rejectRN;
  final GetRNSteps getSteps;

  ReceiptNoteController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.getInventorySettings,
    required this.saveRN,
    required this.confirmRN,
    required this.validateRN,
    required this.cancelRN,
    required this.deleteRN,
    required this.saveTrackingUC,
    required this.createReturnUC,
    required this.approveRN,
    required this.rejectRN,
    required this.getSteps,
  });

  static const int _perPage = 15;

  List<ReceiptNoteModel> _all = [];
  List<ReceiptNoteModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  ReceiptNoteDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ReceiptNoteFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;
  bool _hasBackorder = false;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  List<ReceiptNoteModel> get pageItems {
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

  ReceiptNoteDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  ReceiptNoteFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;
  bool get hasBackorder => _hasBackorder;

  Map<String, dynamic>? get approvalSteps => _approvalSteps;
  bool get isLoadingSteps => _isLoadingSteps;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <ReceiptNoteModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as ReceiptNotePaginationMeta;
        all.addAll(r['items'] as List<ReceiptNoteModel>);
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
          (t.vendorName?.toLowerCase().contains(q) ?? false) ||
          (t.sourceDocument?.toLowerCase().contains(q) ?? false);
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

  Future<ReceiptNoteInventorySettings?> fetchInventorySettings(int productId) async {
    try {
      return await getInventorySettings(productId);
    } catch (_) {
      return null;
    }
  }

  /// status = save (create/update as Draft)
  Future<bool> save(ReceiptNoteFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      _savedEncryption = await saveRN(f);
      _successMessage = f.isEditMode ? 'Receipt Note updated' : 'Receipt Note created';
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

  /// status = confirm
  Future<bool> confirm(ReceiptNoteFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await confirmRN(f);
      _savedEncryption = (result['data'] as Map?)?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Receipt Note confirmed';
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

  /// status = validate.
  /// First call this with [allowBackorder] left null. If the result reports
  /// [hasBackorder] and the backend hasn't already created the backorder
  /// (i.e. it just returned the outcome without deciding), show a
  /// confirmation prompt to the user, then call this again passing their
  /// Yes/No answer as [allowBackorder] to resubmit the same form.
  Future<bool> validateReceipt(ReceiptNoteFormModel f, {bool? allowBackorder}) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    if (allowBackorder == null) _hasBackorder = false;
    notifyListeners();

    try {
      final result = await validateRN(f, allowBackorder: allowBackorder);
      _hasBackorder = result['has_backorder'] == true;
      _successMessage = result['message']?.toString() ?? 'Receipt Note validated';
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
      await cancelRN(encryption, reason);
      _successMessage = 'Receipt Note cancelled';
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
      await deleteRN(id);
      _successMessage = 'Receipt Note deleted';
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

  Future<bool> saveTracking({
    required int idReceiptNoteItem,
    required double receivedQty,
    required List<ReceiptNoteLotSerial> trackingData,
  }) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await saveTrackingUC(
        idReceiptNoteItem: idReceiptNoteItem,
        receivedQty: receivedQty,
        trackingData: trackingData,
      );
      _successMessage = 'Tracking data saved';
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

  Future<bool> createReturn(String encryption) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      final result = await createReturnUC(encryption);
      _successMessage = result['message']?.toString() ?? 'Return created';
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
      await approveRN(id);
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
      await rejectRN(id);
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
    _hasBackorder = false;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}