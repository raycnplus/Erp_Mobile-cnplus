import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/models/leave_request_models.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/domain/usecases/leave_request_usecases.dart';

class LeaveRequestController extends ChangeNotifier {
  final GetLeaveRequestList getLeaveRequestList;
  final GetLeaveRequestDetail getLeaveRequestDetail;
  final GetLeaveRequestFormOptions getLeaveRequestFormOptions;
  final CreateLeaveRequest createLeaveRequest;
  final UpdateLeaveRequest updateLeaveRequest;
  final DeleteLeaveRequest deleteLeaveRequest;
  final ApproveLeaveRequest approveLeaveRequest;
  final RejectLeaveRequest rejectLeaveRequest;

  LeaveRequestController({
    required this.getLeaveRequestList,
    required this.getLeaveRequestDetail,
    required this.getLeaveRequestFormOptions,
    required this.createLeaveRequest,
    required this.updateLeaveRequest,
    required this.deleteLeaveRequest,
    required this.approveLeaveRequest,
    required this.rejectLeaveRequest,
  });

  List<LeaveRequestModel> _all = [];
  List<LeaveRequestModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';
  String? _statusFilter;

  LeaveRequestDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  LeaveRequestFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<LeaveRequestModel> get pageItems {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filtered.length);
    if (start >= _filtered.length) return [];
    return _filtered.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;

  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < lastPage;

  LeaveRequestDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  LeaveRequestFormOptions? get formOptions => _formOptions;
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
      final all = <LeaveRequestModel>[];
      int page = 1;
      while (true) {
        final result = await getLeaveRequestList(
          page: page,
          perPage: 100,
          status: _statusFilter,
        );
        final meta = result['meta'] as LeaveRequestPaginationMeta;
        all.addAll(result['items'] as List<LeaveRequestModel>);
        if (page >= meta.lastPage) break;
        page++;
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
    final query = _searchQuery.toLowerCase();
    _filtered = _all.where((item) {
      return (item.employeeName?.toLowerCase().contains(query) ?? false) ||
          (item.leaveTypeName?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void search(String query) {
    _searchQuery = query.trim();
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

  void goToPage(int page) {
    if (page < 1 || page > lastPage) return;
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _detail = await getLeaveRequestDetail(enc);
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
      _formOptions = await getLeaveRequestFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<bool> saveDraft(LeaveRequestFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      _savedEncryption = await createLeaveRequest(form, status: 'save');
      _successMessage = 'Leave request saved as draft';
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

  Future<bool> createAndSubmit(LeaveRequestFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      _savedEncryption = await createLeaveRequest(form, status: 'submit');
      _successMessage = 'Leave request submitted for approval';
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

  Future<bool> updateDraft(int idLeaveRequest, LeaveRequestFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      _savedEncryption =
          await updateLeaveRequest(idLeaveRequest, form, status: 'save');
      _successMessage = 'Draft updated';
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

  Future<bool> submitDraft(
    int idLeaveRequest,
    LeaveRequestFormModel form,
  ) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      _savedEncryption =
          await updateLeaveRequest(idLeaveRequest, form, status: 'submit');
      _successMessage = 'Leave request submitted for approval';
      await fetchList(status: _statusFilter);
      final enc = _savedEncryption ?? form.encryption;
      if (enc?.isNotEmpty == true) await fetchDetail(enc!);
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
    _successMessage = null;
    notifyListeners();
    try {
      await deleteLeaveRequest(enc);
      _successMessage = 'Leave request deleted';
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
      await approveLeaveRequest(id);
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
      await rejectLeaveRequest(id, notes: notes);
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

  String _msg(dynamic e) =>
      e.toString().replaceFirst('Exception:', '').trim();
}