import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/data/models/product_category_models.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/domain/usecases/product_category_usecases.dart';

class ProductCategoryController extends ChangeNotifier {
  final GetProductCategoryList getProductCategoryList;
  final GetProductCategoryDetail getProductCategoryDetail;
  final CreateProductCategory createProductCategory;
  final UpdateProductCategory updateProductCategory;
  final DeleteProductCategory deleteProductCategory;

  ProductCategoryController({
    required this.getProductCategoryList,
    required this.getProductCategoryDetail,
    required this.createProductCategory,
    required this.updateProductCategory,
    required this.deleteProductCategory,
  });

  List<ProductCategoryModel> _allCategories = [];
  List<ProductCategoryModel> _filteredCategories = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  ProductCategoryDetailModel? _categoryDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<ProductCategoryModel> get categoryList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredCategories.length);
    if (start >= _filteredCategories.length) return [];
    return _filteredCategories.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredCategories.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredCategories.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;
  String get searchQuery => _searchQuery;

  ProductCategoryDetailModel? get categoryDetail => _categoryDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchCategoryList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final List<ProductCategoryModel> all = [];
      int fetchPage = 1;

      while (true) {
        final result =
            await getProductCategoryList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as ProductCategoryPaginationMeta;
        final items = result['items'] as List<ProductCategoryModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }

      _allCategories = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allCategories = [];
      _filteredCategories = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredCategories = _allCategories
          .where((c) => c.productCategoryName.toLowerCase().contains(q))
          .toList();
    }
  }

  void searchCategories(String query) {
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

  Future<void> fetchCategoryDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _categoryDetail = await getProductCategoryDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _categoryDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveCategory(ProductCategoryFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createProductCategory(formData);
      _successMessage = 'Product category created successfully';
      await fetchCategoryList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editCategory(
      String encryption, ProductCategoryFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption =
          await updateProductCategory(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Product category updated successfully';
      await fetchCategoryList();
      await fetchCategoryDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeCategory(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteProductCategory(encryption);
      _successMessage = 'Product category deleted successfully';
      await fetchCategoryList();
      if (categoryList.isEmpty && _currentPage > 1) _currentPage--;
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearErrors() {
    _formError = null;
    _listError = null;
    _detailError = null;
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