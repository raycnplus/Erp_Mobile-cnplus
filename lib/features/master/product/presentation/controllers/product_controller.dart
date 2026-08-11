import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';
import 'package:erp_mobile_cnplus/features/master/product/domain/usecases/product_usecases.dart';

class ProductController extends ChangeNotifier {
  final GetProductList getProductList;
  final GetProductDetail getProductDetail;
  final GetProductFormDropdownData getFormDropdownData;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductController({
    required this.getProductList,
    required this.getProductDetail,
    required this.getFormDropdownData,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  });

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  ProductDetailModel? _productDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  ProductDropdownData? _dropdownData;
  bool _isLoadingDropdown = false;
  bool _dropdownLoaded = false;
  String? _dropdownError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<ProductModel> get productList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredProducts.length);
    if (start >= _filteredProducts.length) return [];
    return _filteredProducts.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredProducts.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredProducts.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  ProductDetailModel? get productDetail => _productDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  ProductDropdownData? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;
  String? get dropdownError => _dropdownError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchProductList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final List<ProductModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result = await getProductList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as ProductPaginationMeta;
        final items = result['items'] as List<ProductModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }
      _allProducts = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allProducts = [];
      _filteredProducts = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredProducts = _allProducts.where((p) {
        return p.productName.toLowerCase().contains(q) ||
            p.productCode.toLowerCase().contains(q);
      }).toList();
    }
  }

  void searchProducts(String query) {
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

  Future<void> fetchFormDropdownData({bool forceRefresh = false}) async {
    if (_dropdownLoaded && !forceRefresh) return;
    _isLoadingDropdown = true;
    _dropdownError = null;
    notifyListeners();
    try {
      _dropdownData = await getFormDropdownData();
      _dropdownLoaded = true;
    } catch (e) {
      _dropdownError = _extractMessage(e);
    } finally {
      _isLoadingDropdown = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _productDetail = await getProductDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _productDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveProduct(ProductFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createProduct(formData);
      _successMessage = 'Product created successfully';
      await fetchProductList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editProduct(String encryption, ProductFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateProduct(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Product updated successfully';
      await fetchProductList();
      await fetchProductDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeProduct(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteProduct(encryption);
      _successMessage = 'Product deleted successfully';
      await fetchProductList();
      if (productList.isEmpty && _currentPage > 1) _currentPage--;
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
    _productDetail = null;
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