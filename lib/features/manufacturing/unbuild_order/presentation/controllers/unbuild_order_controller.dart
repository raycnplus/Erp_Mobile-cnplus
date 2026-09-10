import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/models/unbuild_order_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/domain/usecases/unbuild_order_usecases.dart';

class UnbuildOrderController extends ChangeNotifier {
  final GetUOList getList;
  final GetUODetail getDetail;
  final GetUOFormOptions getFormOptions;
  final GenerateUOReference generateReference;
  final GetUOComponentsPreview getComponentsPreview;
  final GetUOManufacturingOrderDetails getManufacturingOrderDetails;
  final SaveUnbuildOrder saveUO;
  final DeleteUnbuildOrder deleteUO;
  final ApproveUnbuildOrder approveUO;
  final RejectUnbuildOrder rejectUO;
  final GetUOSteps getSteps;

  UnbuildOrderController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.generateReference,
    required this.getComponentsPreview,
    required this.getManufacturingOrderDetails,
    required this.saveUO,
    required this.deleteUO,
    required this.approveUO,
    required this.rejectUO,
    required this.getSteps,
  });

  static const int _perPage = 15;

  List<UnbuildOrderModel> _all = [];
  List<UnbuildOrderModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  UnbuildOrderDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  UnbuildOrderFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  bool _isLoadingMoDetails = false;
  UOManufacturingOrderDetails? _selectedMoDetails;

  bool _isLoadingPreview = false;
  List<UOPreviewComponent> _previewComponents = [];

  List<UnbuildOrderModel> get pageItems {
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

  UnbuildOrderDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  UnbuildOrderFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Map<String, dynamic>? get approvalSteps => _approvalSteps;
  bool get isLoadingSteps => _isLoadingSteps;

  bool get isLoadingMoDetails => _isLoadingMoDetails;
  UOManufacturingOrderDetails? get selectedMoDetails => _selectedMoDetails;

  bool get isLoadingPreview => _isLoadingPreview;
  List<UOPreviewComponent> get previewComponents => _previewComponents;

  bool get hasFormOptionsError => _formOptionsError != null;
  String? _formOptionsError;
  String? get formOptionsError => _formOptionsError;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <UnbuildOrderModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as UOPaginationMeta;
        all.addAll(r['items'] as List<UnbuildOrderModel>);
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
          (t.moReference?.toLowerCase().contains(q) ?? false);
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
    _formOptionsError = null;
    notifyListeners();

    try {
      _formOptions = await getFormOptions();
      _optionsLoaded = true;
    } catch (e) {
      _formOptions = null;
      _optionsLoaded = false;      
      _formOptionsError = _msg(e); 
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  void resetFormOptions() {
    _optionsLoaded = false;
    _formOptions = null;
    _formOptionsError = null;
  }

  Future<void> fetchManufacturingOrderDetails(int moId) async {
    _isLoadingMoDetails = true;
    notifyListeners();

    try {
      _selectedMoDetails = await getManufacturingOrderDetails(moId);
    } catch (_) {
      _selectedMoDetails = null;
    } finally {
      _isLoadingMoDetails = false;
      notifyListeners();
    }
  }

  Future<void> fetchComponentsPreview(List<UOPreviewRequestItem> items) async {
    _isLoadingPreview = true;
    notifyListeners();

    try {
      _previewComponents = await getComponentsPreview(items);
    } catch (_) {
      _previewComponents = [];
    } finally {
      _isLoadingPreview = false;
      notifyListeners();
    }
  }

  Future<bool> save(UnbuildOrderFormModel f, {String status = 'save'}) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      _savedEncryption = await saveUO(f, status);
      _successMessage = switch (status) {
        'confirm' => 'Unbuild Order confirmed',
        'validate' => 'Unbuild Order validated',
        _ => f.isEditMode ? 'Unbuild Order updated' : 'Unbuild Order created',
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

  Future<bool> remove(String enc) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await deleteUO(enc);
      _successMessage = 'Unbuild Order deleted';
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

  Future<bool> approve(String enc) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await approveUO(enc);
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

  Future<bool> reject(String enc) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await rejectUO(enc);
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

  Future<void> loadSteps(String enc) async {
    _isLoadingSteps = true;
    _approvalSteps = null;
    notifyListeners();

    try {
      _approvalSteps = await getSteps(enc);
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
    _selectedMoDetails = null;
    _previewComponents = [];
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}