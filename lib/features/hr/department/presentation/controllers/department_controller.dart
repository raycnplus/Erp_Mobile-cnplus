import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/models/department_models.dart';
import 'package:erp_mobile_cnplus/features/hr/department/domain/usecases/department_usecases.dart';

class DepartmentController extends ChangeNotifier {
  final GetDepartmentList getDepartmentList;
  final GetDepartmentDetail getDepartmentDetail;
  final CreateDepartment createDepartment;
  final UpdateDepartment updateDepartment;
  final DeleteDepartment deleteDepartment;

  DepartmentController({
    required this.getDepartmentList,
    required this.getDepartmentDetail,
    required this.createDepartment,
    required this.updateDepartment,
    required this.deleteDepartment,
  });

  List<DepartmentModel> _all = [], _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  DepartmentDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;
  bool _isSaving = false;
  String? _formError, _successMessage, _updatedEncryption;

  List<DepartmentModel> get pageItems {
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

  DepartmentDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;
  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true; _listError = null; notifyListeners();
    try {
      final all = <DepartmentModel>[]; int p = 1;
      while (true) {
        final r = await getDepartmentList(page: p, perPage: 100);
        final meta = r['meta'] as DepartmentPaginationMeta;
        all.addAll(r['items'] as List<DepartmentModel>);
        if (p >= meta.lastPage) break; p++;
      }
      _all = all; _applyFilter(); _currentPage = 1;
    } catch (e) { _listError = _msg(e); _all = []; _filtered = []; }
    finally { _isLoadingList = false; notifyListeners(); }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) { _filtered = List.from(_all); return; }
    final q = _searchQuery.toLowerCase();
    _filtered = _all.where((t) =>
      t.departmentName.toLowerCase().contains(q) ||
      (t.departmentDescription?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  void search(String query) { _searchQuery = query.trim(); _currentPage = 1; _applyFilter(); notifyListeners(); }
  void clearSearch() { _searchQuery = ''; _currentPage = 1; _applyFilter(); notifyListeners(); }
  void goToPage(int p) { if (p < 1 || p > lastPage) return; _currentPage = p; notifyListeners(); }
  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true; _detailError = null; notifyListeners();
    try { _detail = await getDepartmentDetail(enc); }
    catch (e) { _detailError = _msg(e); _detail = null; }
    finally { _isLoadingDetail = false; notifyListeners(); }
  }

  Future<bool> save(DepartmentFormModel f) async {
    _isSaving = true; _formError = null; _successMessage = null; notifyListeners();
    try { await createDepartment(f); _successMessage = 'Department created successfully'; await fetchList(); return true; }
    catch (e) { _formError = _msg(e); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  Future<bool> edit(String enc, DepartmentFormModel f) async {
    _isSaving = true; _formError = null; _successMessage = null; _updatedEncryption = null; notifyListeners();
    try {
      final ne = await updateDepartment(enc, f);
      _updatedEncryption = ne; _successMessage = 'Department updated successfully';
      await fetchList(); await fetchDetail(ne); return true;
    }
    catch (e) { _formError = _msg(e); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  Future<bool> remove(String enc) async {
    _isSaving = true; _formError = null; _successMessage = null; notifyListeners();
    try {
      await deleteDepartment(enc); _successMessage = 'Department deleted successfully';
      await fetchList(); if (pageItems.isEmpty && _currentPage > 1) _currentPage--;
      return true;
    }
    catch (e) { _formError = _msg(e); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  void resetDetailState() { _detail = null; _detailError = null; _updatedEncryption = null; notifyListeners(); }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}