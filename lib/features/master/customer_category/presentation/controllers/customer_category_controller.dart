import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/models/customer_category_models.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/domain/usecases/customer_category_usecases.dart';

class CustomerCategoryController extends ChangeNotifier {
  final GetCustomerCategoryList getCustomerCategoryList;
  final GetCustomerCategoryDetail getCustomerCategoryDetail;
  final CreateCustomerCategory createCustomerCategory;
  final UpdateCustomerCategory updateCustomerCategory;
  final DeleteCustomerCategory deleteCustomerCategory;

  CustomerCategoryController({
    required this.getCustomerCategoryList,
    required this.getCustomerCategoryDetail,
    required this.createCustomerCategory,
    required this.updateCustomerCategory,
    required this.deleteCustomerCategory,
  });

  List<CustomerCategoryModel> _allCategories = [];
  List<CustomerCategoryModel> _filteredCategories = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  CustomerCategoryDetailModel? _categoryDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<CustomerCategoryModel> get categoryList {
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

  CustomerCategoryDetailModel? get categoryDetail => _categoryDetail;
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
      final List<CustomerCategoryModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result =
            await getCustomerCategoryList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as CustomerCategoryPaginationMeta;
        final items = result['items'] as List<CustomerCategoryModel>;
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
      _filteredCategories = _allCategories.where((c) {
        return c.customerCategoryName.toLowerCase().contains(q) ||
            c.customerCategoryCode.toLowerCase().contains(q) ||
            (c.description?.toLowerCase().contains(q) ?? false);
      }).toList();
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
      _categoryDetail = await getCustomerCategoryDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _categoryDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveCategory(CustomerCategoryFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createCustomerCategory(formData);
      _successMessage = 'Customer category created successfully';
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
      String encryption, CustomerCategoryFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption =
          await updateCustomerCategory(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Customer category updated successfully';
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
      await deleteCustomerCategory(encryption);
      _successMessage = 'Customer category deleted successfully';
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

  void resetDetailState() {
    _categoryDetail = null;
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