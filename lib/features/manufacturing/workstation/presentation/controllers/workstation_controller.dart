import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/models/workstation_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/domain/usecases/workstation_usecases.dart';

class WorkstationController extends ChangeNotifier {
  final GetWorkstationList getList;
  final GetWorkstationDetail getDetail;
  final CreateWorkstation createWorkstation;
  final UpdateWorkstation updateWorkstation;
  final DeleteWorkstation deleteWorkstation;

  WorkstationController({
    required this.getList,
    required this.getDetail,
    required this.createWorkstation,
    required this.updateWorkstation,
    required this.deleteWorkstation,
  });

  static const int _perPage = 15;

  List<WorkstationModel> _all = [];
  List<WorkstationModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';

  WorkstationDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<WorkstationModel> get pageItems {
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

  WorkstationDetailModel? get detail => _detail;
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
      final all = <WorkstationModel>[];
      int p = 1;

      while (true) {
        final r = await getList(page: p, perPage: 100);
        final meta = r['meta'] as WorkstationPaginationMeta;
        all.addAll(r['items'] as List<WorkstationModel>);
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
      return t.workstationName.toLowerCase().contains(q) ||
          t.workstationCode.toLowerCase().contains(q);
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

  Future<bool> save(WorkstationFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await createWorkstation(f);
      _successMessage = 'Workstation created';
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

  Future<bool> edit(String enc, WorkstationFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();

    try {
      final ne = await updateWorkstation(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Workstation updated';
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
      await deleteWorkstation(enc);
      _successMessage = 'Workstation deleted';
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

  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}