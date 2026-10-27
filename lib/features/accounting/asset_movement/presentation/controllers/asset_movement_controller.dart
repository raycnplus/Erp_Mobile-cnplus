import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/models/asset_movement_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/domain/usecases/asset_movement_usecases.dart';

class AssetMovementController extends ChangeNotifier {
  final GetAssetMovementList getList;
  final GetAssetMovementDetail getDetail;
  final GetAssetMovementFormOptions getFormOptions;
  final SaveAssetMovement saveAM;

  AssetMovementController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveAM,
  });

  static const int _perPage = 15;

  List<AssetMovementModel> _all = [];
  List<AssetMovementModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _startDate;
  String? _endDate;

  AssetMovementDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  AssetMovementFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<AssetMovementModel> get pageItems {
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

  AssetMovementDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  AssetMovementFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Future<void> fetchList({String? startDate, String? endDate}) async {
    _startDate = startDate;
    _endDate = endDate;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <AssetMovementModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page: p, perPage: 100,
          search: _searchQuery.isEmpty ? null : _searchQuery,
          startDate: _startDate, endDate: _endDate,
        );
        final meta = r['meta'] as AssetMovementPaginationMeta;
        all.addAll(r['items'] as List<AssetMovementModel>);
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
        (t.reference?.toLowerCase().contains(q) ?? false) ||
        (t.assetCode?.toLowerCase().contains(q) ?? false) ||
        (t.assetName?.toLowerCase().contains(q) ?? false) ||
        (t.fromLocation?.toLowerCase().contains(q) ?? false) ||
        (t.toLocation?.toLowerCase().contains(q) ?? false)).toList();
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

  Future<void> fetchFormOptions() async {
    _isLoadingOptions = true;
    notifyListeners();
    try {
      _formOptions = await getFormOptions();
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<bool> save(AssetMovementFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveAM(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Asset moved successfully';
      await fetchList(startDate: _startDate, endDate: _endDate);
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

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').replaceFirst('Save failed:', '').trim();
}