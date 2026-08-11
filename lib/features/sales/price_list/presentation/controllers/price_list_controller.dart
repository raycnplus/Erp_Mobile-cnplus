import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/domain/usecases/price_list_usecases.dart';

class PriceListController extends ChangeNotifier {
  final GetPriceListList getList;
  final GetPriceListDetail getDetail;
  final GetPriceListProducts getProducts;
  final CreatePriceList createPriceList;
  final UpdatePriceList updatePriceList;
  final DeletePriceList deletePriceList;

  PriceListController({
    required this.getList,
    required this.getDetail,
    required this.getProducts,
    required this.createPriceList,
    required this.updatePriceList,
    required this.deletePriceList,
  });

  List<PriceListModel> _all = [], _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  PriceListDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  List<PriceListProductOption> _products = [];
  bool _isLoadingProducts = false;
  bool _productsLoaded = false;

  bool _isSaving = false;
  String? _formError, _successMessage, _updatedEncryption;

  List<PriceListModel> get pageItems {
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

  PriceListDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  List<PriceListProductOption> get products => _products;
  bool get isLoadingProducts => _isLoadingProducts;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <PriceListModel>[];
      int p = 1;
      while (true) {
        final r = await getList(page: p, perPage: 100);
        final meta = r['meta'] as PriceListPaginationMeta;
        all.addAll(r['items'] as List<PriceListModel>);
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
    _filtered = _all.where((p) => p.priceListName.toLowerCase().contains(q)).toList();
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

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_productsLoaded && !forceRefresh) return;
    _isLoadingProducts = true;
    notifyListeners();
    try {
      _products = await getProducts();
      _productsLoaded = true;
    } catch (e) {
      _products = [];
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

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

  Future<bool> save(PriceListFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createPriceList(f);
      _successMessage = 'Price list created successfully';
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

  Future<bool> edit(String enc, PriceListFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final ne = await updatePriceList(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Price list updated successfully';
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
      await deletePriceList(enc);
      _successMessage = 'Price list deleted';
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