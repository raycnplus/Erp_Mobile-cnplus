import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/models/vendor_models.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/domain/usecases/vendor_usecases.dart';

class VendorController extends ChangeNotifier {
  final GetVendorList getVendorList;
  final GetVendorDetail getVendorDetail;
  final GetVendorFormDropdownData getFormDropdownData;
  final CreateVendor createVendor;
  final UpdateVendor updateVendor;
  final DeleteVendor deleteVendor;

  VendorController({
    required this.getVendorList,
    required this.getVendorDetail,
    required this.getFormDropdownData,
    required this.createVendor,
    required this.updateVendor,
    required this.deleteVendor,
  });

  List<VendorModel> _allVendors = [];
  List<VendorModel> _filteredVendors = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  VendorDetailModel? _vendorDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  List<CountryModel> _countries = [];
  List<CurrencyModel> _currencies = [];
  bool _isLoadingDropdown = false;
  String? _dropdownError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<VendorModel> get vendorList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredVendors.length);
    if (start >= _filteredVendors.length) return [];
    return _filteredVendors.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredVendors.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredVendors.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;
  String get searchQuery => _searchQuery;

  VendorDetailModel? get vendorDetail => _vendorDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  List<CountryModel> get countries => _countries;
  List<CurrencyModel> get currencies => _currencies;
  bool get isLoadingDropdown => _isLoadingDropdown;
  String? get dropdownError => _dropdownError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchVendorList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final List<VendorModel> all = [];
      int fetchPage = 1;

      while (true) {
        final result = await getVendorList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as VendorPaginationMeta;
        final items = result['items'] as List<VendorModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }

      _allVendors = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allVendors = [];
      _filteredVendors = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredVendors = List.from(_allVendors);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredVendors = _allVendors.where((v) {
        return v.vendorName.toLowerCase().contains(q) ||
            v.vendorCode.toLowerCase().contains(q) ||
            (v.email?.toLowerCase().contains(q) ?? false) ||
            (v.contactPersonName?.toLowerCase().contains(q) ?? false) ||
            (v.city?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
  }

  void searchVendors(String query) {
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

  bool _dropdownLoaded = false;

  Future<void> fetchFormDropdownData({bool forceRefresh = false}) async {
    if (_dropdownLoaded && !forceRefresh) return;

    _isLoadingDropdown = true;
    _dropdownError = null;
    notifyListeners();
    try {
      final data = await getFormDropdownData();
      _countries = data['countries'] as List<CountryModel>;
      _currencies = data['currencies'] as List<CurrencyModel>;
      _dropdownLoaded = true;
    } catch (e) {
      _dropdownError = _extractMessage(e);
    } finally {
      _isLoadingDropdown = false;
      notifyListeners();
    }
  }

  Future<void> fetchVendorDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _vendorDetail = await getVendorDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _vendorDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveVendor(VendorFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createVendor(formData);
      _successMessage = 'Vendor created successfully';
      await fetchVendorList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editVendor(String encryption, VendorFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateVendor(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Vendor updated successfully';
      await fetchVendorList();
      await fetchVendorDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeVendor(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteVendor(encryption);
      _successMessage = 'Vendor deleted successfully';
      await fetchVendorList();
      if (vendorList.isEmpty && _currentPage > 1) _currentPage--;
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

  void resetDetailState() {
    _vendorDetail = null;
    _detailError = null;
    _updatedEncryption = null;
    notifyListeners();
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}