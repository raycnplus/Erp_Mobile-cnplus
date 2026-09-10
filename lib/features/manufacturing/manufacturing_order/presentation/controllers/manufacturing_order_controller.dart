import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/domain/usecases/manufacturing_order_usecases.dart';

class ManufacturingOrderController extends ChangeNotifier {
  final GetMOList getList;
  final GetMODetail getDetail;
  final GetMOFormOptions getFormOptions;
  final GetMOProductBoms getProductBoms;
  final GetMOBomDetails getBomDetails;
  final GetMOBomComponents getBomComponents;
  final GetMOPlanMaterials getPlanMaterials;
  final SaveManufacturingOrder saveMO;
  final DeleteManufacturingOrder deleteMO;
  final ApproveManufacturingOrder approveMO;
  final RejectManufacturingOrder rejectMO;
  final GetMOSteps getSteps;
  final CreateUnbuildFromMO createUnbuild;
  final StartMOOperation startOperation;
  final PauseMOOperation pauseOperation;
  final ResumeMOOperation resumeOperation;
  final CompleteMOOperation completeOperation;

  ManufacturingOrderController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.getProductBoms,
    required this.getBomDetails,
    required this.getBomComponents,
    required this.getPlanMaterials,
    required this.saveMO,
    required this.deleteMO,
    required this.approveMO,
    required this.rejectMO,
    required this.getSteps,
    required this.createUnbuild,
    required this.startOperation,
    required this.pauseOperation,
    required this.resumeOperation,
    required this.completeOperation,
  });

  static const int _perPage = 15;

  List<ManufacturingOrderModel> _all = [];
  List<ManufacturingOrderModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  ManufacturingOrderDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ManufacturingOrderFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  Map<String, dynamic>? _approvalSteps;
  bool _isLoadingSteps = false;

  bool _isLoadingBom = false;
  List<MOBomOption> _productBomOptions = [];
  MOBomDetail? _selectedBomDetail;
  List<MOBomComponent> _bomComponents = [];
  List<MOPlanMaterial> _planMaterials = [];

  List<ManufacturingOrderModel> get pageItems {
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

  ManufacturingOrderDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  ManufacturingOrderFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Map<String, dynamic>? get approvalSteps => _approvalSteps;
  bool get isLoadingSteps => _isLoadingSteps;

  bool get isLoadingBom => _isLoadingBom;
  List<MOBomOption> get productBomOptions => _productBomOptions;
  MOBomDetail? get selectedBomDetail => _selectedBomDetail;
  List<MOBomComponent> get bomComponents => _bomComponents;
  List<MOPlanMaterial> get planMaterials => _planMaterials;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <ManufacturingOrderModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as MOPaginationMeta;
        all.addAll(r['items'] as List<ManufacturingOrderModel>);
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
          (t.productName?.toLowerCase().contains(q) ?? false);
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

  Future<void> fetchProductBoms(int productId) async {
    _isLoadingBom = true;
    notifyListeners();

    try {
      final result = await getProductBoms(productId);
      _productBomOptions = result.boms;
    } catch (_) {
      _productBomOptions = [];
    } finally {
      _isLoadingBom = false;
      notifyListeners();
    }
  }

  Future<void> fetchBomDetails(int bomId) async {
    _isLoadingBom = true;
    notifyListeners();

    try {
      _selectedBomDetail = await getBomDetails(bomId);
    } catch (_) {
      _selectedBomDetail = null;
    } finally {
      _isLoadingBom = false;
      notifyListeners();
    }
  }

  Future<void> fetchBomComponents(int bomId, {double qty = 1}) async {
    _isLoadingBom = true;
    notifyListeners();

    try {
      _bomComponents = await getBomComponents(bomId, qty: qty);
    } catch (_) {
      _bomComponents = [];
    } finally {
      _isLoadingBom = false;
      notifyListeners();
    }
  }

  Future<void> fetchPlanMaterials({
    required int bomId,
    double qty = 1,
    required int warehouseId,
    required int locationId,
    int? manufacturingOrderId,
  }) async {
    _isLoadingBom = true;
    notifyListeners();

    try {
      _planMaterials = await getPlanMaterials(
        bomId: bomId,
        qty: qty,
        warehouseId: warehouseId,
        locationId: locationId,
        manufacturingOrderId: manufacturingOrderId,
      );
    } catch (_) {
      _planMaterials = [];
    } finally {
      _isLoadingBom = false;
      notifyListeners();
    }
  }

  Future<bool> save(ManufacturingOrderFormModel f, {String status = 'save'}) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      _savedEncryption = await saveMO(f, status);
      _successMessage = switch (status) {
        'confirm' => 'Manufacturing Order confirmed',
        'validate' => 'Manufacturing Order validated',
        _ => f.isEditMode ? 'Manufacturing Order updated' : 'Manufacturing Order created',
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
      await deleteMO(enc);
      _successMessage = 'Manufacturing Order deleted';
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
      await approveMO(enc);
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
      await rejectMO(enc);
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

  Future<bool> generateUnbuild(String enc) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      final result = await createUnbuild(enc);
      _successMessage = result.message.isNotEmpty ? result.message : 'Unbuild Order created';
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

  Future<bool> startMoOperation(int moId, int bomOperationId) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await startOperation(moId, bomOperationId);
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

  Future<bool> pauseMoOperation(int trackingId) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await pauseOperation(trackingId);
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

  Future<bool> resumeMoOperation(int trackingId) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await resumeOperation(trackingId);
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

  Future<bool> completeMoOperation(int trackingId) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await completeOperation(trackingId);
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
    _selectedBomDetail = null;
    _bomComponents = [];
    _planMaterials = [];
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}