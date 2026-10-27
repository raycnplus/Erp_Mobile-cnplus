import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/models/fixed_asset_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/domain/usecases/fixed_asset_usecases.dart';

class FixedAssetController extends ChangeNotifier {
  final GetFixedAssetList getList;
  final GetFixedAssetDetail getDetail;
  final GetFixedAssetFormOptions getFormOptions;
  final SaveFixedAsset saveFA;
  final DeleteFixedAsset deleteFA;

  FixedAssetController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveFA,
    required this.deleteFA,
  });

  static const int _perPage = 15;

  List<FixedAssetModel> _all = [];
  List<FixedAssetModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  FixedAssetDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  FixedAssetFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<FixedAssetModel> get pageItems {
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

  FixedAssetDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  FixedAssetFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <FixedAssetModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page: p, perPage: 100,
          search: _searchQuery.isEmpty ? null : _searchQuery,
          assetStatus: _statusFilter,
        );
        final meta = r['meta'] as FixedAssetPaginationMeta;
        all.addAll(r['items'] as List<FixedAssetModel>);
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
        t.assetCode.toLowerCase().contains(q) ||
        t.assetName.toLowerCase().contains(q) ||
        (t.categoryName?.toLowerCase().contains(q) ?? false)).toList();
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

  Future<bool> save(FixedAssetFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveFA(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Fixed Asset saved successfully';
      await fetchList(status: _statusFilter);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      if (_formError!.toLowerCase().contains('no query results')) {
        await fetchList(status: _statusFilter);
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
      await deleteFA(encryption);
      _successMessage = 'Fixed Asset deleted';
      await fetchList(status: _statusFilter);
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
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}