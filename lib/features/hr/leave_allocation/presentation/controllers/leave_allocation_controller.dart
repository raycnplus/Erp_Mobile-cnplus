import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/models/leave_allocation_models.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/domain/usecases/leave_allocation_usecases.dart';

class LeaveAllocationController extends ChangeNotifier {
  final GetLeaveAllocationList getList;
  final GetLeaveAllocationDetail getDetail;
  final GetLeaveAllocationFormOptions getFormOptions;
  final CreateLeaveAllocation createAllocation;
  final UpdateLeaveAllocation updateAllocation;
  final DeleteLeaveAllocation deleteAllocation;

  LeaveAllocationController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.createAllocation,
    required this.updateAllocation,
    required this.deleteAllocation,
  });

  static const int _perPage = 15;

  List<LeaveAllocationModel> _all = [];
  List<LeaveAllocationModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  int? _filterYear;

  LeaveAllocationDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  LeaveAllocationFormOptions? _formOptions;
  bool _isLoadingFormOptions = false;
  bool _formOptionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<LeaveAllocationModel> get pageItems {
    final start = (_currentPage - 1) * _perPage;
    if (start >= _filtered.length) return [];
    final end = (start + _perPage).clamp(0, _filtered.length);
    return _filtered.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < lastPage;
  int? get filterYear => _filterYear;

  LeaveAllocationDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  LeaveAllocationFormOptions? get formOptions => _formOptions;
  bool get isLoadingFormOptions => _isLoadingFormOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList({int? year}) async {
    _filterYear = year;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <LeaveAllocationModel>[];
      int page = 1;

      while (true) {
        final result = await getList(page: page, perPage: 100, year: year);
        final meta = result['meta'] as LeaveAllocationPaginationMeta;
        all.addAll(result['items'] as List<LeaveAllocationModel>);
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

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_formOptionsLoaded && !forceRefresh) return;
    _isLoadingFormOptions = true;
    notifyListeners();

    try {
      _formOptions = await getFormOptions();
      _formOptionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingFormOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      _detail = await getDetail(encryption);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(LeaveAllocationFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await createAllocation(form);
      _successMessage = 'Leave allocation created successfully';
      await fetchList(year: _filterYear);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> edit(String encryption, LeaveAllocationFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();

    try {
      final ne = await updateAllocation(encryption, form);
      _updatedEncryption = ne;
      _successMessage = 'Leave allocation updated successfully';
      await fetchList(year: _filterYear);
      await fetchDetail(ne);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> remove(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await deleteAllocation(encryption);
      _successMessage = 'Leave allocation deleted';
      await fetchList(year: _filterYear);
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

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    _updatedEncryption = null;
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_all);
      return;
    }
    final q = _searchQuery.toLowerCase();
    _filtered = _all.where((item) {
      return item.allocationName.toLowerCase().contains(q) ||
          item.leaveType.toLowerCase().contains(q);
    }).toList();
  }

  String _msg(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}