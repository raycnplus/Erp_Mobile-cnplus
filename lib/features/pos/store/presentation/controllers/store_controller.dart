import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/models/store_models.dart';
import 'package:erp_mobile_cnplus/features/pos/store/domain/usecases/store_usecases.dart';

class StoreController extends ChangeNotifier {
  final GetStoreList getStoreList;
  final GetStoreDetail getStoreDetail;
  final GetStoreOptions getStoreOptions;
  final CreateStore createStore;
  final UpdateStore updateStore;
  final DeleteStore deleteStore;
  final SelectStore selectStore;
  final VerifyStorePin verifyStorePin;

  StoreController({
    required this.getStoreList,
    required this.getStoreDetail,
    required this.getStoreOptions,
    required this.createStore,
    required this.updateStore,
    required this.deleteStore,
    required this.selectStore,
    required this.verifyStorePin,
  });

  static const int _perPage = 15;

  List<StoreModel> _all = [];
  List<StoreModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  bool _posRequirePin = false;

  StoreDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  StoreFormOptions _formOptions = StoreFormOptions.empty();
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<StoreModel> get pageItems {
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
  bool get posRequirePin => _posRequirePin;

  StoreDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  StoreFormOptions get formOptions => _formOptions;
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
      final all = <StoreModel>[];
      int p = 1;

      while (true) {
        final r = await getStoreList(page: p, perPage: 100);
        final meta = r['meta'] as StorePaginationMeta;
        all.addAll(r['items'] as List<StoreModel>);
        _posRequirePin = r['pos_require_pin'] as bool? ?? false;
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
    _filtered = _all.where((s) {
      return s.storeName.toLowerCase().contains(q) ||
          s.address.toLowerCase().contains(q);
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
      _detail = await getStoreDetail(enc);
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
      _formOptions = await getStoreOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = StoreFormOptions.empty();
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<bool> save(StoreFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await createStore(f);
      _successMessage = 'Store created';
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

  Future<bool> edit(String enc, StoreFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();

    try {
      final ne = await updateStore(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Store updated';
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
      await deleteStore(enc);
      _successMessage = 'Store deleted';
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

  Future<Map<String, dynamic>> doSelectStore(int idStore) async {
    _isSaving = true;
    notifyListeners();

    try {
      return await selectStore(idStore);
    } catch (e) {
      return {'success': false, 'message': _msg(e)};
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> doVerifyPin(String enc, String pin) async {
    _isSaving = true;
    notifyListeners();

    try {
      return await verifyStorePin(enc, pin);
    } catch (e) {
      return {'success': false, 'message': _msg(e)};
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