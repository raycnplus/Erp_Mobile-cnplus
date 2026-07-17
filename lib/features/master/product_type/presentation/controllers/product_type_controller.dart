import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/models/product_type_models.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/domain/usecases/product_type_usecases.dart';

class ProductTypeController extends ChangeNotifier {
  final GetProductTypeList getProductTypeList;
  final GetProductTypeDetail getProductTypeDetail;
  final CreateProductType createProductType;
  final UpdateProductType updateProductType;
  final DeleteProductType deleteProductType;

  ProductTypeController({
    required this.getProductTypeList,
    required this.getProductTypeDetail,
    required this.createProductType,
    required this.updateProductType,
    required this.deleteProductType,
  });

  List<ProductTypeModel> _allTypes = [];
  List<ProductTypeModel> _filteredTypes = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  ProductTypeDetailModel? _typeDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<ProductTypeModel> get typeList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredTypes.length);
    if (start >= _filteredTypes.length) return [];
    return _filteredTypes.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredTypes.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredTypes.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  ProductTypeDetailModel? get typeDetail => _typeDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchTypeList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final List<ProductTypeModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result = await getProductTypeList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as ProductTypePaginationMeta;
        final items = result['items'] as List<ProductTypeModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }
      _allTypes = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allTypes = [];
      _filteredTypes = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredTypes = List.from(_allTypes);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredTypes = _allTypes
          .where((t) => t.productTypeName.toLowerCase().contains(q))
          .toList();
    }
  }

  void searchTypes(String query) {
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

  Future<void> fetchTypeDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _typeDetail = await getProductTypeDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _typeDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveType(ProductTypeFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createProductType(formData);
      _successMessage = 'Product type created successfully';
      await fetchTypeList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editType(String encryption, ProductTypeFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateProductType(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Product type updated successfully';
      await fetchTypeList();
      await fetchTypeDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeType(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteProductType(encryption);
      _successMessage = 'Product type deleted successfully';
      await fetchTypeList();
      if (typeList.isEmpty && _currentPage > 1) _currentPage--;
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _typeDetail = null;
    _detailError = null;
    _updatedEncryption = null;
    notifyListeners();
  }

  void clearMessages() {
    _successMessage = null;
    _formError = null;
    notifyListeners();
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}