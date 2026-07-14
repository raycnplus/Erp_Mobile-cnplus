import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/models/bank_account_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/domain/usecases/bank_account_usecases.dart';

class BankAccountController extends ChangeNotifier {
  final GetBankAccountList getList;
  final GetBankAccountDetail getDetail;
  final GetBankAccountFormOptions getFormOptions;
  final CreateBankAccount createBankAccount;
  final UpdateBankAccount updateBankAccount;
  final DeleteBankAccount deleteBankAccount;

  BankAccountController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.createBankAccount,
    required this.updateBankAccount,
    required this.deleteBankAccount,
  });

  List<BankAccountModel> _all = [];
  List<BankAccountModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  BankAccountDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  BankAccountFormOptions? _formOptions;
  bool _isLoadingFormOptions = false;
  bool _formOptionsLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<BankAccountModel> get pageItems {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filtered.length);
    if (start >= _filtered.length) return [];
    return _filtered.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;

  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < lastPage;

  BankAccountDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  BankAccountFormOptions? get formOptions => _formOptions;
  bool get isLoadingFormOptions => _isLoadingFormOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <BankAccountModel>[];
      int page = 1;
      while (true) {
        final result = await getList(page: page, perPage: 100);
        final meta = result['meta'] as BankAccountPaginationMeta;
        all.addAll(result['items'] as List<BankAccountModel>);
        if (page >= meta.lastPage) break;
        page++;
      }
      _all = all;
      _applyFilter();
      _currentPage = 1;
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
    final query = _searchQuery.toLowerCase();
    _filtered = _all.where((item) {
      return item.bankName.toLowerCase().contains(query) ||
          item.bankAccountName.toLowerCase().contains(query) ||
          item.bankAccountNumber.contains(query);
    }).toList();
  }

  void search(String query) {
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

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_formOptionsLoaded && !forceRefresh) return;
    _isLoadingFormOptions = true;
    notifyListeners();
    try {
      _formOptions = await getFormOptions();
      _formOptionsLoaded = true;
    } catch (e) {
      _formOptions = null;
    } finally {
      _isLoadingFormOptions = false;
      notifyListeners();
    }
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

  Future<bool> save(BankAccountFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createBankAccount(form);
      _successMessage = 'Bank account created successfully';
      await fetchList();
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> edit(String enc, BankAccountFormModel form) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEnc = await updateBankAccount(enc, form);
      _updatedEncryption = newEnc;
      _successMessage = 'Bank account updated successfully';
      await fetchList();
      await fetchDetail(newEnc);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> remove(String enc) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteBankAccount(enc);
      _successMessage = 'Bank account deleted';
      await fetchList();
      if (pageItems.isEmpty && _currentPage > 1) _currentPage--;
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    _updatedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}