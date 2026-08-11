import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/models/delivery_note_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/domain/usecases/delivery_note_usecases.dart';

class DeliveryNoteController extends ChangeNotifier {
  final GetDNList getList;
  final GetDNDetail getDetail;
  final GetDNFormOptions getFormOptions;
  final SaveDeliveryNote saveDN;
  final ConfirmDeliveryNote confirmDN;
  final ValidateDeliveryNote validateDN;
  final CancelDeliveryNote cancelDN;
  final DeleteDeliveryNote deleteDN;
  final SaveDNTracking saveTrackingUC;
  final GetDNProductsByLocation getProductsByLocation;
  final CheckDNStock checkStockUC;
  final GetDNSteps getSteps;
  final ApproveDeliveryNote approveDN;
  final RejectDeliveryNote rejectDN;
  final GetDNLotSerialsSorted getLotSerialsSortedUC;
  final CreateReturnFromDeliveryNote createReturnUC;

  DeliveryNoteController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveDN,
    required this.confirmDN,
    required this.validateDN,
    required this.cancelDN,
    required this.deleteDN,
    required this.saveTrackingUC,
    required this.getProductsByLocation,
    required this.checkStockUC,
    required this.getSteps,
    required this.approveDN,
    required this.rejectDN,
    required this.getLotSerialsSortedUC,
    required this.createReturnUC,
  });

  static const int _perPage = 15;

  List<DeliveryNoteModel> _all = [];
  List<DeliveryNoteModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  DeliveryNoteDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  DeliveryNoteFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;
  bool _hasBackorder = false;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  bool _isLoadingProducts = false;
  List<Map<String, dynamic>> _locationProducts = [];

  List<DeliveryNoteModel> get pageItems {
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

  DeliveryNoteDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  DeliveryNoteFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;
  bool get hasBackorder => _hasBackorder;

  Map<String, dynamic>? get approvalSteps => _approvalSteps;
  bool get isLoadingSteps => _isLoadingSteps;
  bool get isLoadingProducts => _isLoadingProducts;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <DeliveryNoteModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as DeliveryNotePaginationMeta;
        all.addAll(r['items'] as List<DeliveryNoteModel>);
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

  Future<bool> save(DeliveryNoteFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await saveDN(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ??
          (f.isEditMode ? 'Delivery Note updated' : 'Delivery Note created');
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

  Future<bool> confirm(DeliveryNoteFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await confirmDN(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Delivery Note confirmed';
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

  Future<bool> validate(DeliveryNoteFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _hasBackorder = false;
    notifyListeners();

    try {
      final result = await validateDN(f);
      _hasBackorder = result['has_backorder'] == true;
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Delivery Note validated';
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
      await cancelDN(encryption, reason);
      _successMessage = 'Delivery Note cancelled';
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
      await deleteDN(id);
      _successMessage = 'Delivery Note deleted';
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
    required int idDeliveryNoteItem,
    required double deliveredQty,
    List<Map<String, dynamic>>? trackingData,
  }) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      final result = await saveTrackingUC(
        idDeliveryNoteItem: idDeliveryNoteItem,
        deliveredQty: deliveredQty,
        trackingData: trackingData,
      );
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
    _formError = null;
    notifyListeners();

    try {
      await approveDN(id);
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
      await rejectDN(id);
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

  Future<bool> createReturn(String encryption) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      final result = await createReturnUC(encryption);
      _successMessage = result['message']?.toString() ?? 'Return created';
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
    _hasBackorder = false;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}