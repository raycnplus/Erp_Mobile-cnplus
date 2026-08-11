import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/user/data/models/user_models.dart';
import 'package:erp_mobile_cnplus/features/master/user/domain/usecases/user_usecases.dart';

class UserController extends ChangeNotifier {
  final GetUserList getUserList;
  final GetUserDetail getUserDetail;
  final ToggleUserStatus toggleUserStatus;
  final DeleteUser deleteUser;

  UserController({
    required this.getUserList,
    required this.getUserDetail,
    required this.toggleUserStatus,
    required this.deleteUser,
  });

  List<UserModel> _all = [];
  List<UserModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  UserDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;

  List<UserModel> get pageItems {
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

  UserDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <UserModel>[];
      int page = 1;
      while (true) {
        final result = await getUserList(page: page, perPage: 100);
        final meta = result['meta'] as UserPaginationMeta;
        all.addAll(result['items'] as List<UserModel>);
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
    _filtered = _all.where((u) {
      return u.namaLengkap.toLowerCase().contains(query) ||
          u.username.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query);
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

  Future<void> fetchDetail(int id) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _detail = await getUserDetail(id);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> toggleStatus(int id) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final newStatus = await toggleUserStatus(id);
      _successMessage = 'Status changed to $newStatus';
      await fetchList();
      if (_detail != null) await fetchDetail(id);
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
    _successMessage = null;
    notifyListeners();
    try {
      await deleteUser(id);
      _successMessage = 'User deleted';
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
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}