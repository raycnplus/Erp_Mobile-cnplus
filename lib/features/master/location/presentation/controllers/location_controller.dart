import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/models/location_models.dart';
import 'package:erp_mobile_cnplus/features/master/location/domain/usecases/location_usecases.dart';

class LocationController extends ChangeNotifier {
  final GetLocationList getLocationList;
  final GetLocationDetail getLocationDetail;
  final GetLocationFormDropdownData getFormDropdownData;
  final CreateLocation createLocation;
  final UpdateLocation updateLocation;
  final DeleteLocation deleteLocation;

  LocationController({
    required this.getLocationList,
    required this.getLocationDetail,
    required this.getFormDropdownData,
    required this.createLocation,
    required this.updateLocation,
    required this.deleteLocation,
  });

  List<LocationModel> _allLocations = [];
  List<LocationModel> _filteredLocations = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  LocationDetailModel? _locationDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  LocationDropdownData? _dropdownData;
  bool _isLoadingDropdown = false;
  bool _dropdownLoaded = false;
  String? _dropdownError;


  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<LocationModel> get locationList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredLocations.length);
    if (start >= _filteredLocations.length) return [];
    return _filteredLocations.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredLocations.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredLocations.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  LocationDetailModel? get locationDetail => _locationDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  LocationDropdownData? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;
  String? get dropdownError => _dropdownError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchLocationList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final List<LocationModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result = await getLocationList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as LocationPaginationMeta;
        final items = result['items'] as List<LocationModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }
      _allLocations = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allLocations = [];
      _filteredLocations = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredLocations = List.from(_allLocations);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredLocations = _allLocations.where((l) {
        return l.locationName.toLowerCase().contains(q) ||
            l.locationCode.toLowerCase().contains(q) ||
            l.warehouseName.toLowerCase().contains(q) ||
            l.parentLocationName.toLowerCase().contains(q);
      }).toList();
    }
  }

  void searchLocations(String query) {
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

  Future<void> fetchLocationDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _locationDetail = await getLocationDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _locationDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveLocation(LocationFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createLocation(formData);
      _successMessage = 'Location created successfully';
      await fetchLocationList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editLocation(String encryption, LocationFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateLocation(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Location updated successfully';
      await fetchLocationList();
      await fetchLocationDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeLocation(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteLocation(encryption);
      _successMessage = 'Location deleted successfully';
      await fetchLocationList();
      if (locationList.isEmpty && _currentPage > 1) _currentPage--;
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
    _locationDetail = null;
    _detailError = null;
    _updatedEncryption = null;
    notifyListeners();
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