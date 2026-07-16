import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/models/customer_models.dart';
import 'package:erp_mobile_cnplus/features/master/customer/domain/usecases/customer_usecases.dart';

class CustomerController extends ChangeNotifier {
  final GetCustomerList getCustomerList;
  final GetCustomerDetail getCustomerDetail;
  final GetCustomerFormDropdownData getFormDropdownData;
  final CreateCustomer createCustomer;
  final UpdateCustomer updateCustomer;
  final DeleteCustomer deleteCustomer;

  CustomerController({
    required this.getCustomerList,
    required this.getCustomerDetail,
    required this.getFormDropdownData,
    required this.createCustomer,
    required this.updateCustomer,
    required this.deleteCustomer,
  });

  List<CustomerModel> _allCustomers = [];
  List<CustomerModel> _filteredCustomers = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  CustomerDetailModel? _customerDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  CustomerDropdownData? _dropdownData;
  bool _isLoadingDropdown = false;
  bool _dropdownLoaded = false;
  String? _dropdownError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<CustomerModel> get customerList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredCustomers.length);
    if (start >= _filteredCustomers.length) return [];
    return _filteredCustomers.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredCustomers.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredCustomers.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  CustomerDetailModel? get customerDetail => _customerDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  CustomerDropdownData? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;
  String? get dropdownError => _dropdownError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchCustomerList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final List<CustomerModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result = await getCustomerList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as CustomerPaginationMeta;
        final items = result['items'] as List<CustomerModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }
      _allCustomers = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allCustomers = [];
      _filteredCustomers = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredCustomers = List.from(_allCustomers);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredCustomers = _allCustomers.where((c) {
        return c.customerName.toLowerCase().contains(q) ||
            c.customerCode.toLowerCase().contains(q) ||
            (c.email?.toLowerCase().contains(q) ?? false) ||
            (c.phoneNo?.toLowerCase().contains(q) ?? false) ||
            (c.city?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
  }

  void searchCustomers(String query) {
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

  Future<void> fetchCustomerDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _customerDetail = await getCustomerDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _customerDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveCustomer(CustomerFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createCustomer(formData);
      _successMessage = 'Customer created successfully';
      await fetchCustomerList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editCustomer(
      String encryption, CustomerFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateCustomer(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Customer updated successfully';
      await fetchCustomerList();
      await fetchCustomerDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeCustomer(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteCustomer(encryption);
      _successMessage = 'Customer deleted successfully';
      await fetchCustomerList();
      if (customerList.isEmpty && _currentPage > 1) _currentPage--;
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
    _customerDetail = null;
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