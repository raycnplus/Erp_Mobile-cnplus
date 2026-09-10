import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/datasources/bpe_management_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/models/bpe_management_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/domain/usecases/bpe_management_usecases.dart';

class BpeManagementController extends ChangeNotifier {
  final GetBpeList getList;
  final GetBpeDetail getDetail;
  final SaveBpe saveBpe;
  final ConfirmBpe confirmBpe;
  final ValidateBpe validateBpe;
  final DeleteBpe deleteBpe;
  final SearchAvailableInvoices searchInvoices;

  BpeManagementController({
    required this.getList,
    required this.getDetail,
    required this.saveBpe,
    required this.confirmBpe,
    required this.validateBpe,
    required this.deleteBpe,
    required this.searchInvoices,
  });

  List<BpeModel> _items = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  String? _statusFilter;
  String? _searchQuery;

  List<BpeModel> get items => _items;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < _lastPage;

  BpeDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  BpeDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  bool _isSearchingInvoices = false;
  List<BpeAvailableInvoice> _availableInvoices = [];

  bool get isSearchingInvoices => _isSearchingInvoices;
  List<BpeAvailableInvoice> get availableInvoices => _availableInvoices;

  Future<void> fetchList({String? status, String? search, int page = 1}) async {
    _statusFilter = status;
    _searchQuery = search;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final r = await getList(page: page, perPage: 15, status: status, search: search);
      final meta = r['meta'] as BpePaginationMeta;
      _items = r['items'] as List<BpeModel>;
      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;
    } catch (e) {
      _listError = _msg(e);
      _items = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void goToPage(int p) {
    if (p < 1 || p > _lastPage) return;
    fetchList(status: _statusFilter, search: _searchQuery, page: p);
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<void> fetchDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      _detail = await getDetail(encryption);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(BpeFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final saved = await saveBpe(f);
      _savedEncryption = saved.encryption;
      _successMessage = f.isEditMode ? 'BPE updated' : 'BPE created';
      await fetchList(status: _statusFilter, search: _searchQuery, page: _currentPage);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> confirm(BpeFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final saved = await confirmBpe(f);
      _savedEncryption = saved.encryption;
      _successMessage = 'BPE confirmed';
      await fetchList(status: _statusFilter, search: _searchQuery, page: _currentPage);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> validate(BpeFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await validateBpe(f);
      _successMessage = 'BPE validated';
      await fetchList(status: _statusFilter, search: _searchQuery, page: _currentPage);
      if (f.encryption != null) await fetchDetail(f.encryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> remove(String encryption) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await deleteBpe(encryption);
      _successMessage = 'BPE deleted';
      await fetchList(status: _statusFilter, search: _searchQuery, page: _currentPage);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<List<BpeAvailableInvoice>> fetchAvailableInvoices({String? keyword, int? exceptBpeId}) async {
    _isSearchingInvoices = true;
    notifyListeners();

    try {
      _availableInvoices = await searchInvoices(keyword: keyword, exceptBpeId: exceptBpeId);
      return _availableInvoices;
    } catch (_) {
      _availableInvoices = [];
      return [];
    } finally {
      _isSearchingInvoices = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}