import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/models/asset_category_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/domain/usecases/asset_category_usecases.dart';

class AssetCategoryController extends ChangeNotifier {
  final GetAssetCategoryList getList;
  final GetAssetCategoryDetail getDetail;
  final GetAssetCategoryFormOptions getFormOptions;
  final SaveAssetCategory saveAC;
  final DeleteAssetCategory deleteAC;

  AssetCategoryController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveAC,
    required this.deleteAC,
  });

  static const int _perPage = 15;

  List<AssetCategoryModel> _all = [];
  List<AssetCategoryModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _methodFilter;

  AssetCategoryDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  AssetCategoryFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;
  List<String> _warnings = [];

  List<AssetCategoryModel> get pageItems {
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

  AssetCategoryDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  AssetCategoryFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;
  List<String> get warnings => _warnings;

  Future<void> fetchList({String? depreciationMethod}) async {
    _methodFilter = depreciationMethod;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <AssetCategoryModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page: p, perPage: 100,
          search: _searchQuery.isEmpty ? null : _searchQuery,
          depreciationMethod: _methodFilter,
        );
        final meta = r['meta'] as AssetCategoryPaginationMeta;
        all.addAll(r['items'] as List<AssetCategoryModel>);
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
    _filtered = _all.where((t) =>
        t.categoryName.toLowerCase().contains(q) ||
        (t.categoryCode?.toLowerCase().contains(q) ?? false)).toList();
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

  Future<bool> save(AssetCategoryFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _warnings = [];
    notifyListeners();
    try {
      final result = await saveAC(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Asset Category saved successfully';
      _warnings = (result['warnings'] as List? ?? []).map((e) => e.toString()).toList();
      await fetchList(depreciationMethod: _methodFilter);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      if (_formError!.toLowerCase().contains('no query results')) {
        await fetchList(depreciationMethod: _methodFilter);
      }
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> remove(String encryption) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      await deleteAC(encryption);
      _successMessage = 'Asset Category deleted';
      await fetchList(depreciationMethod: _methodFilter);
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
    _warnings = [];
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}