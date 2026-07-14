import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/models/overtime_type_models.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/domain/usecases/overtime_type_usecases.dart';

class OvertimeTypeController extends ChangeNotifier {
  final GetOvertimeTypeList getList;
  final GetOvertimeTypeDetail getDetail;
  final GetOvertimeTypeFormOptions getFormOptions;
  final CreateOvertimeType createOT;
  final UpdateOvertimeType updateOT;
  final DeleteOvertimeType deleteOT;

  OvertimeTypeController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.createOT,
    required this.updateOT,
    required this.deleteOT,
  });

  static const int _perPage = 15;

  List<OvertimeTypeModel> _all = [];
  List<OvertimeTypeModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';

  OvertimeTypeDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  List<OvertimeCategoryOption> _categories = [];
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<OvertimeTypeModel> get pageItems {
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

  OvertimeTypeDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  List<OvertimeCategoryOption> get categories => _categories;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <OvertimeTypeModel>[];
      int p = 1;

      while (true) {
        final r = await getList(page: p, perPage: 100);
        final meta = r['meta'] as OvertimeTypePaginationMeta;
        all.addAll(r['items'] as List<OvertimeTypeModel>);
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
      return t.name.toLowerCase().contains(q) ||
          t.category.toLowerCase().contains(q);
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
      _categories = await getFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _categories = [];
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<bool> save(OvertimeTypeFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await createOT(f);
      _successMessage = 'Overtime type created';
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

  Future<bool> edit(String enc, OvertimeTypeFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();

    try {
      final ne = await updateOT(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Overtime type updated';
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
      await deleteOT(enc);
      _successMessage = 'Overtime type deleted';
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

  String _msg(dynamic e) =>
      e.toString().replaceFirst('Exception:', '').trim();
}