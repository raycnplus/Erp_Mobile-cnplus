import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/models/asset_depreciation_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/domain/usecases/asset_depreciation_usecases.dart';

class AssetDepreciationController extends ChangeNotifier {
  final GetAssetDepreciationList        getList;
  final GetAssetDepreciationDetail      getDetail;
  final GetAssetDepreciationFormOptions getFormOptions;
  final RunAssetDepreciation            runDep;

  AssetDepreciationController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.runDep,
  });

  List<AssetDepreciationModel> _all      = [];
  List<AssetDepreciationModel> _filtered = [];
  bool _isLoadingList        = false;
  String? _listError;
  int _currentPage           = 1;
  static const int _perPage  = 15;
  String _searchQuery        = '';
  int? _yearFilter;

  AssetDepreciationDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  AssetDepreciationFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded    = false;
  bool _isSaving         = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<AssetDepreciationModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  bool get isLoadingList                      => _isLoadingList;
  String? get listError                       => _listError;
  int get currentPage                         => _currentPage;
  int get lastPage                            => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total                               => _filtered.length;
  bool get hasPrev                            => _currentPage > 1;
  bool get hasNext                            => _currentPage < lastPage;
  AssetDepreciationDetailModel? get detail    => _detail;
  bool get isLoadingDetail                    => _isLoadingDetail;
  String? get detailError                     => _detailError;
  AssetDepreciationFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions                   => _isLoadingOptions;
  bool get isSaving                           => _isSaving;
  String? get formError                       => _formError;
  String? get successMessage                  => _successMessage;
  String? get savedEncryption                 => _savedEncryption;

  Future<void> fetchList({int? year}) async {
    _yearFilter    = year;
    _isLoadingList = true;
    _listError     = null;
    notifyListeners();
    try {
      final all = <AssetDepreciationModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page:    p,
          perPage: 100,
          year:    _yearFilter,
          search:  _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as AssetDepreciationPaginationMeta;
        all.addAll(r['items'] as List<AssetDepreciationModel>);
        if (p >= meta.lastPage) break;
        p++;
      }
      _all = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _msg(e);
      _all       = [];
      _filtered  = [];
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
    _filtered = _all.where((t) => t.reference?.toLowerCase().contains(q) ?? false).toList();
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
    _detailError     = null;
    notifyListeners();
    try {
      _detail = await getDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail      = null;
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
      _formOptions   = await getFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<bool> run(AssetDepreciationFormModel f) async {
    _isSaving       = true;
    _formError      = null;
    _successMessage = null;
    notifyListeners();
    try {
      _savedEncryption = await runDep(f);
      await fetchList(year: _yearFilter);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      final n = _detail?.totalAssetsProcessed;
      _successMessage = n != null ? 'Depreciation run for $n asset(s)' : 'Depreciation run successfully';
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
    _detail          = null;
    _detailError     = null;
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e
      .toString()
      .replaceFirst('Exception:', '')
      .trim()
      .replaceFirst(RegExp(r'^(Save|Run|Confirm|Post|Cancel|Delete) failed:\s*'), '');
}