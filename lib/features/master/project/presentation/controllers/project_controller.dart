import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';
import 'package:erp_mobile_cnplus/features/master/project/domain/usecases/project_usecases.dart';

class ProjectController extends ChangeNotifier {
  final GetProjectList getProjectList;
  final GetProjectDetail getProjectDetail;
  final GetProjectFormOptions getFormOptions;
  final CreateProject createProject;
  final UpdateProject updateProject;
  final DeleteProject deleteProject;

  ProjectController({
    required this.getProjectList,
    required this.getProjectDetail,
    required this.getFormOptions,
    required this.createProject,
    required this.updateProject,
    required this.deleteProject,
  });

  List<ProjectModel> _all = [], _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  ProjectDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ProjectFormOptions? _formOptions;
  bool _isLoadingFormOptions = false;
  bool _formOptionsLoaded = false;

  bool _isSaving = false;
  String? _formError, _successMessage, _updatedEncryption;

  List<ProjectModel> get pageItems {
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

  ProjectDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  ProjectFormOptions? get formOptions => _formOptions;
  bool get isLoadingFormOptions => _isLoadingFormOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <ProjectModel>[];
      int p = 1;
      while (true) {
        final r = await getProjectList(page: p, perPage: 100);
        final meta = r['meta'] as ProjectPaginationMeta;
        all.addAll(r['items'] as List<ProjectModel>);
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
    _filtered = _all.where((p) =>
      p.projectName.toLowerCase().contains(q) ||
      p.projectCode.toLowerCase().contains(q) ||
      p.customer.toLowerCase().contains(q),
    ).toList();
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

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_formOptionsLoaded && !forceRefresh) return;
    _isLoadingFormOptions = true;
    notifyListeners();
    try {
      _formOptions = await getFormOptions();
      _formOptionsLoaded = true;
    } catch (e) {
      _formOptions = null;
    } finally {
      _isLoadingFormOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _detail = await getProjectDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(ProjectFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createProject(f);
      _successMessage = 'Project created successfully';
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

  Future<bool> edit(String enc, ProjectFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final ne = await updateProject(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Project updated successfully';
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
      await deleteProject(enc);
      _successMessage = 'Project deleted';
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