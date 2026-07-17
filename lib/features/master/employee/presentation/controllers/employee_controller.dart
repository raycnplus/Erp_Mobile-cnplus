import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';
import 'package:erp_mobile_cnplus/features/master/employee/domain/usecases/employee_usecases.dart';

class EmployeeController extends ChangeNotifier {
  final GetEmployeeList getEmployeeList;
  final GetEmployeeDetail getEmployeeDetail;
  final GetEmployeeFormOptions getFormOptions;
  final CreateEmployee createEmployee;
  final UpdateEmployee updateEmployee;
  final DeleteEmployee deleteEmployee;
  final CreateEmployeeUserAccount createUserAccount;

  EmployeeController({
    required this.getEmployeeList,
    required this.getEmployeeDetail,
    required this.getFormOptions,
    required this.createEmployee,
    required this.updateEmployee,
    required this.deleteEmployee,
    required this.createUserAccount,
  });

  static const int _perPage = 15;

  List<EmployeeModel> _all = [];
  List<EmployeeModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';

  EmployeeDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  EmployeeDropdownData? _dropdownData;
  bool _isLoadingDropdown = false;
  bool _dropdownLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;
  String? _createdUsername;
  String? _createdPassword;

  List<EmployeeModel> get pageItems {
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

  EmployeeDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  EmployeeDropdownData? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;
  List<RoleDropdown> get roles => _dropdownData?.roles ?? [];

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;
  String? get createdUsername => _createdUsername;
  String? get createdPassword => _createdPassword;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <EmployeeModel>[];
      int p = 1;

      while (true) {
        final r = await getEmployeeList(page: p, perPage: 100);
        final meta = r['meta'] as EmployeePaginationMeta;
        all.addAll(r['items'] as List<EmployeeModel>);
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
      return t.employeeName.toLowerCase().contains(q) ||
          (t.email?.toLowerCase().contains(q) ?? false) ||
          (t.phoneNumber?.contains(q) ?? false) ||
          t.departmentName.toLowerCase().contains(q) ||
          t.positionName.toLowerCase().contains(q);
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

  Future<void> fetchFormDropdownData({bool forceRefresh = false}) async {
    if (_dropdownLoaded && !forceRefresh) return;
    _isLoadingDropdown = true;
    notifyListeners();

    try {
      _dropdownData = await getFormOptions();
      _dropdownLoaded = true;
    } catch (e) {
      _dropdownData = null;
    } finally {
      _isLoadingDropdown = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      _detail = await getEmployeeDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(EmployeeFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final enc = await createEmployee(f);
      _updatedEncryption = enc;
      _successMessage = 'Employee created successfully';
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

  Future<bool> edit(String enc, EmployeeFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();

    try {
      final ne = await updateEmployee(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Employee updated successfully';
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
      await deleteEmployee(enc);
      _successMessage = 'Employee deleted successfully';
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

  Future<bool> makeUserAccount(String enc, int idRole) async {
    _isSaving = true;
    _formError = null;
    _createdUsername = null;
    _createdPassword = null;
    notifyListeners();

    try {
      final result = await createUserAccount(enc, idRole);
      _createdUsername = result['username'];
      _createdPassword = result['password'];
      _successMessage = 'User account created successfully';
      await fetchDetail(enc);
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

  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}