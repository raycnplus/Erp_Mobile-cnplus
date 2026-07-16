import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart';
import 'package:erp_mobile_cnplus/features/master/brand/domain/usecases/brand_usecases.dart';

class BrandController extends ChangeNotifier {
  final GetBrandList getBrandList;
  final GetBrandDetail getBrandDetail;
  final CreateBrand createBrand;
  final UpdateBrand updateBrand;
  final DeleteBrand deleteBrand;

  BrandController({
    required this.getBrandList,
    required this.getBrandDetail,
    required this.createBrand,
    required this.updateBrand,
    required this.deleteBrand,
  });

  List<BrandModel> _brandList = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  static const int _perPage = 15;
  String _searchQuery = '';

  BrandDetailModel? _brandDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<BrandModel> get brandList => _brandList;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  int get perPage => _perPage;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < _lastPage;
  String get searchQuery => _searchQuery;

  BrandDetailModel? get brandDetail => _brandDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchBrandList({int page = 1, String? search}) async {
    if (search != null) _searchQuery = search;

    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final result = await getBrandList(
        page: page,
        perPage: _perPage,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );
      final meta = result['meta'] as BrandPaginationMeta;
      _brandList = result['items'] as List<BrandModel>;
      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;
    } catch (e) {
      _listError = _extractMessage(e);
      _brandList = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  Future<void> goToPage(int page) => fetchBrandList(page: page);
  Future<void> nextPage() => fetchBrandList(page: _currentPage + 1);
  Future<void> prevPage() => fetchBrandList(page: _currentPage - 1);
  Future<void> searchBrands(String query) => fetchBrandList(page: 1, search: query);

  void clearSearch() {
    _searchQuery = '';
    fetchBrandList(page: 1);
  }

  Future<void> fetchBrandDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _brandDetail = await getBrandDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _brandDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveBrand(BrandFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createBrand(formData);
      _successMessage = 'Brand created successfully';
      await fetchBrandList(page: 1);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editBrand(String encryption, BrandFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateBrand(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Brand updated successfully';

      await fetchBrandList(page: _currentPage);
      await fetchBrandDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeBrand(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteBrand(encryption);
      _successMessage = 'Brand deleted successfully';
      final targetPage = _brandList.length == 1 && _currentPage > 1
          ? _currentPage - 1
          : _currentPage;
      await fetchBrandList(page: targetPage);
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