import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/models/bom_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/domain/usecases/bom_usecases.dart';

class BomController extends ChangeNotifier {
  final GetBomList getBomList;
  final GetBomDetail getBomDetail;
  final GetBomFormOptions getFormOptions;
  final CreateBom createBom;
  final UpdateBom updateBom;
  final DeleteBom deleteBom;

  BomController({
    required this.getBomList,
    required this.getBomDetail,
    required this.getFormOptions,
    required this.createBom,
    required this.updateBom,
    required this.deleteBom,
  });

  List<BomModel> _all = [];
  List<BomModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  BomDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  BomFormOptions? _formOptions;
  bool _isLoadingFormOptions = false;
  bool _formOptionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<BomModel> get pageItems {
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

  BomDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  BomFormOptions? get formOptions => _formOptions;
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
      final all = <BomModel>[];
      int page = 1;
      while (true) {
        final result = await getBomList(page: page, perPage: 100);
        final meta = result['meta'] as BomPaginationMeta;
        all.addAll(result['items'] as List<BomModel>);
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
    _filtered = _all.where((item) {
      return item.bomName.toLowerCase().contains(query) ||
          item.productName.toLowerCase().contains(query);
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
      _detail = await getBomDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(BomFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createBom(form);
      _successMessage = 'BOM created successfully';
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

  Future<bool> edit(String enc, BomFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEnc = await updateBom(enc, form);
      _updatedEncryption = newEnc;
      _successMessage = 'BOM updated successfully';
      await fetchList();
      await fetchDetail(newEnc);
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
      await deleteBom(enc);
      _successMessage = 'BOM deleted';
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