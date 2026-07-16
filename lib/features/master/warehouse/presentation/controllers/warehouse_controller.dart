import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/domain/usecases/warehouse_usecases.dart';

class WarehouseController extends ChangeNotifier {
  final GetWarehouseList getWarehouseList;
  final GetWarehouseDetail getWarehouseDetail;
  final CreateWarehouse createWarehouse;
  final UpdateWarehouse updateWarehouse;
  final DeleteWarehouse deleteWarehouse;

  WarehouseController({
    required this.getWarehouseList,
    required this.getWarehouseDetail,
    required this.createWarehouse,
    required this.updateWarehouse,
    required this.deleteWarehouse,
  });

  List<WarehouseModel> _allWarehouses = [];
  List<WarehouseModel> _filteredWarehouses = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  WarehouseDetailModel? _warehouseDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<WarehouseModel> get warehouseList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredWarehouses.length);
    if (start >= _filteredWarehouses.length) return [];
    return _filteredWarehouses.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredWarehouses.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredWarehouses.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  WarehouseDetailModel? get warehouseDetail => _warehouseDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchWarehouseList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final List<WarehouseModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result = await getWarehouseList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as WarehousePaginationMeta;
        final items = result['items'] as List<WarehouseModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }
      _allWarehouses = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allWarehouses = [];
      _filteredWarehouses = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredWarehouses = List.from(_allWarehouses);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredWarehouses = _allWarehouses.where((w) {
        return w.warehouseName.toLowerCase().contains(q) ||
            w.warehouseCode.toLowerCase().contains(q) ||
            (w.branch?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
  }

  void searchWarehouses(String query) {
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

  Future<void> fetchWarehouseDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _warehouseDetail = await getWarehouseDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _warehouseDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveWarehouse(WarehouseFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createWarehouse(formData);
      _successMessage = 'Warehouse created successfully';
      await fetchWarehouseList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editWarehouse(String encryption, WarehouseFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateWarehouse(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Warehouse updated successfully';
      await fetchWarehouseList();
      await fetchWarehouseDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeWarehouse(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteWarehouse(encryption);
      _successMessage = 'Warehouse deleted successfully';
      await fetchWarehouseList();
      if (warehouseList.isEmpty && _currentPage > 1) _currentPage--;
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
    _warehouseDetail = null;
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