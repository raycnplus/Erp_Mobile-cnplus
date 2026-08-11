import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

enum ProductViewMode { list, detail, form }

class ProductController extends ChangeNotifier {
  final ProductRepository repository;

  ProductController({required this.repository});

  // State
  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  ProductViewMode _viewMode = ProductViewMode.list;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, List<dynamic>> _dropdownData = {};

  // Getters
  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;
  ProductViewMode get viewMode => _viewMode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, List<dynamic>> get dropdownData => _dropdownData;

  // Load Products
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await repository.getProducts();
      _viewMode = ProductViewMode.list;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load Product Detail
  Future<void> loadProductDetail(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedProduct = await repository.getProductDetail(id);
      _viewMode = ProductViewMode.detail;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load Dropdown Data
  Future<void> loadDropdownData() async {
    try {
      _dropdownData = await repository.getDropdownData();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Create Product
  Future<bool> createProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newProduct = await repository.createProduct(product);
      _products.insert(0, newProduct);
      _viewMode = ProductViewMode.list;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Product
  Future<bool> updateProduct(int id, ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = await repository.updateProduct(id, product);
      final index = _products.indexWhere((p) => p.idProduct == id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      _selectedProduct = updatedProduct;
      _viewMode = ProductViewMode.detail;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete Product
  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.deleteProduct(id);
      _products.removeWhere((p) => p.idProduct == id);
      _viewMode = ProductViewMode.list;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // View Mode Control
  void showList() {
    _viewMode = ProductViewMode.list;
    _selectedProduct = null;
    notifyListeners();
  }

  void showForm({ProductModel? product}) {
    _selectedProduct = product;
    _viewMode = ProductViewMode.form;
    notifyListeners();
  }

  void showDetail(ProductModel product) {
    _selectedProduct = product;
    _viewMode = ProductViewMode.detail;
    notifyListeners();
  }
}