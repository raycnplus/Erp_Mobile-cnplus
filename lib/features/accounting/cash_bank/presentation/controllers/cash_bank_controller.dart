import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/domain/usecases/cash_bank_usecases.dart';

class CashBankController extends ChangeNotifier {
  final GetCashBankList getList;
  final GetCashBankDetail getDetail;
  final GetCashBankFormOptions getFormOptions;
  final SaveCashBank saveCB;
  final PostCashBank postCB;
  final UnpostCashBank unpostCB;
  final DeleteCashBank deleteCB;
  final BulkPostCashBank bulkPostCB;

  CashBankController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveCB,
    required this.postCB,
    required this.unpostCB,
    required this.deleteCB,
    required this.bulkPostCB,
  });

  static const int _perPage = 15;

  List<CashBankModel> _all = [];
  List<CashBankModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;
  String? _noteTypeFilter;
  String? _startDate;
  String? _endDate;

  CashBankDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  CashBankFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  final Set<String> _selectedEncryptions = {};

  List<CashBankModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < lastPage;

  CashBankDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  CashBankFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Set<String> get selectedEncryptions => _selectedEncryptions;
  bool get hasSelection => _selectedEncryptions.isNotEmpty;

  Future<void> fetchList({String? status, String? noteType, String? startDate, String? endDate}) async {
    _statusFilter = status;
    _noteTypeFilter = noteType;
    _startDate = startDate;
    _endDate = endDate;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <CashBankModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page: p, perPage: 100,
          search: _searchQuery.isEmpty ? null : _searchQuery,
          status: _statusFilter, noteType: _noteTypeFilter,
          startDate: _startDate, endDate: _endDate,
        );
        final meta = r['meta'] as CashBankPaginationMeta;
        all.addAll(r['items'] as List<CashBankModel>);
        if (p >= meta.lastPage) break;
        p++;
      }
      _all = all;
      _applyFilter();
      _currentPage = 1;
      _selectedEncryptions.clear();
    } catch (e) {
      _listError = _msg(e);
      _all = [];
      _filtered = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_all);
      return;
    }
    final q = _searchQuery.toLowerCase();
    _filtered = _all.where((t) =>
        (t.reference?.toLowerCase().contains(q) ?? false) ||
        (t.description?.toLowerCase().contains(q) ?? false)).toList();
  }

  void search(String q) {
    _searchQuery = q.trim();
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

  void goToPage(int p) {
    if (p < 1 || p > lastPage) return;
    _currentPage = p;
    notifyListeners();
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  void toggleSelect(String encryption) {
    if (_selectedEncryptions.contains(encryption)) {
      _selectedEncryptions.remove(encryption);
    } else {
      _selectedEncryptions.add(encryption);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedEncryptions.clear();
    notifyListeners();
  }

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _detail = await getDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_optionsLoaded && !forceRefresh) return;
    _isLoadingOptions = true;
    notifyListeners();
    try {
      _formOptions = await getFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<bool> save(CashBankFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveCB(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Cash & Bank transaction saved as draft';
      await fetchList(status: _statusFilter, noteType: _noteTypeFilter, startDate: _startDate, endDate: _endDate);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> post(CashBankFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await postCB(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Cash & Bank transaction posted successfully';
      await fetchList(status: _statusFilter, noteType: _noteTypeFilter, startDate: _startDate, endDate: _endDate);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> unpost(String encryption) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      final result = await unpostCB(encryption);
      _successMessage = result['message']?.toString() ?? 'Unposted';

      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) {
        _savedEncryption = newEncryption;
      }

      await fetchList(status: _statusFilter, noteType: _noteTypeFilter, startDate: _startDate, endDate: _endDate);

      if (newEncryption != null && newEncryption.isNotEmpty) {
        await fetchDetail(newEncryption);       
      } else if (_detail != null) {
        await fetchDetail(_detail!.encryption);
      }
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
      await deleteCB(encryption);
      _successMessage = 'Cash & Bank transaction deleted';
      await fetchList(status: _statusFilter, noteType: _noteTypeFilter, startDate: _startDate, endDate: _endDate);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<BulkPostResult?> bulkPostSelected() async {
    if (_selectedEncryptions.isEmpty) return null;
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      final result = await bulkPostCB(_selectedEncryptions.toList());
      _selectedEncryptions.clear();
      await fetchList(status: _statusFilter, noteType: _noteTypeFilter, startDate: _startDate, endDate: _endDate);
      return result;
    } catch (e) {
      _formError = _msg(e);
      return null;
    } finally {
      _isSaving = false;
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