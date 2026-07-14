import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/models/overtime_request_models.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/domain/usecases/overtime_request_usecases.dart';

class OvertimeRequestController extends ChangeNotifier {
  final GetOvertimeRequestList getList;
  final GetOvertimeRequestDetail getDetail;
  final GetOvertimeRequestFormOptions getFormOptions;
  final CreateOvertimeRequest createOT;
  final UpdateOvertimeRequest updateOT;
  final DeleteOvertimeRequest deleteOT;
  final ApproveOvertimeRequest approveOT;
  final RejectOvertimeRequest rejectOT;

  OvertimeRequestController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.createOT,
    required this.updateOT,
    required this.deleteOT,
    required this.approveOT,
    required this.rejectOT,
  });

  static const int _perPage = 15;

  List<OvertimeRequestModel> _all = [];
  List<OvertimeRequestModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  OvertimeRequestDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  OvertimeRequestFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<OvertimeRequestModel> get pageItems {
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

  OvertimeRequestDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  OvertimeRequestFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <OvertimeRequestModel>[];
      int p = 1;

      while (true) {
        final r = await getList(page: p, perPage: 100, status: _statusFilter);
        final meta = r['meta'] as OvertimeRequestPaginationMeta;
        all.addAll(r['items'] as List<OvertimeRequestModel>);
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
      return (t.employeeName?.toLowerCase().contains(q) ?? false) ||
          (t.overtimeTypeName?.toLowerCase().contains(q) ?? false);
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

  Future<bool> saveDraft(OvertimeRequestFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (f.isEditMode) {
        _savedEncryption = await updateOT(f.idOvertimeRequest!, f, actionType: 'save');
        _successMessage = 'Draft updated';
      } else {
        _savedEncryption = await createOT(f, actionType: 'save');
        _successMessage = 'Overtime request saved as draft';
      }
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

  Future<bool> saveAndSubmit(OvertimeRequestFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (f.isEditMode) {
        _savedEncryption = await updateOT(f.idOvertimeRequest!, f, actionType: 'submit');
      } else {
        _savedEncryption = await createOT(f, actionType: 'submit');
      }
      _successMessage = 'Overtime request submitted for approval';
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

  Future<bool> submitFromDetail(OvertimeRequestFormModel f) => saveAndSubmit(f);

  Future<bool> remove(String enc) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await deleteOT(enc);
      _successMessage = 'Overtime request deleted';
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

  Future<bool> approve(int id, {double? approvedHours, String? notes}) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await approveOT(id, approvedHours: approvedHours, notes: notes);
      _successMessage = 'Approved';
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

  Future<bool> reject(int id, {String? notes}) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await rejectOT(id, notes: notes);
      _successMessage = 'Rejected';
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

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}