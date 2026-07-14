import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/domain/usecases/employee_status_usecases.dart';

class EmployeeStatusController extends ChangeNotifier {
  final GetEmployeeStatusList getStatusList;
  final GetEmployeeStatusDetail getStatusDetail;
  final CreateEmployeeStatus createStatus;
  final UpdateEmployeeStatus updateStatus;
  final DeleteEmployeeStatus deleteStatus;

  EmployeeStatusController({
    required this.getStatusList,
    required this.getStatusDetail,
    required this.createStatus,
    required this.updateStatus,
    required this.deleteStatus,
  });

  List<EmployeeStatusModel> _all = [];
  List<EmployeeStatusModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  EmployeeStatusDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<EmployeeStatusModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  List<EmployeeStatusModel> get itemList => pageItems;

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < lastPage;
  bool get hasPrevPage => hasPrev;
  bool get hasNextPage => hasNext;

  EmployeeStatusDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <EmployeeStatusModel>[];
      int p = 1;

      while (true) {
        final r = await getStatusList(page: p, perPage: 100);
        final meta = r['meta'] as EmployeeStatusPaginationMeta;
        all.addAll(r['items'] as List<EmployeeStatusModel>);
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
      return t.employeeStatusName.toLowerCase().contains(q);
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
      _detail = await getStatusDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(EmployeeStatusFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await createStatus(f);
      _successMessage = 'Employee status created successfully';
      await fetchList();
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> edit(String enc, EmployeeStatusFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();

    try {
      final ne = await updateStatus(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Employee status updated successfully';
      await fetchList();
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

  Future<bool> remove(String enc) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await deleteStatus(enc);
      _successMessage = 'Employee status deleted successfully';
      await fetchList();
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

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    _updatedEncryption = null;
    notifyListeners();
  }

  void resetDetail() => resetDetailState();

  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}