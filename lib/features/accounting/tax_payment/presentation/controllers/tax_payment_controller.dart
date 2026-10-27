import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/models/tax_payment_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/domain/usecases/tax_payment_usecases.dart';

class TaxPaymentController extends ChangeNotifier {
  final GetTaxPaymentList    getList;
  final GetTaxPaymentDetail  getDetail;
  final SearchTaxTransactions searchTransactionsUC;
  final SaveTaxPayment       saveTP;
  final PostTaxPayment       postTP;
  final UnpostTaxPayment     unpostTP;
  final DeleteTaxPayment     deleteTP;

  TaxPaymentController({
    required this.getList,
    required this.getDetail,
    required this.searchTransactionsUC,
    required this.saveTP,
    required this.postTP,
    required this.unpostTP,
    required this.deleteTP,
  });

  List<TaxPaymentModel> _all      = [];
  List<TaxPaymentModel> _filtered = [];
  bool _isLoadingList        = false;
  String? _listError;
  int _currentPage           = 1;
  static const int _perPage  = 15;
  String _searchQuery        = '';
  String? _statusFilter;

  TaxPaymentDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<TaxPaymentModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  bool get isLoadingList                 => _isLoadingList;
  String? get listError                  => _listError;
  int get currentPage                    => _currentPage;
  int get lastPage                       => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total                          => _filtered.length;
  bool get hasPrev                       => _currentPage > 1;
  bool get hasNext                       => _currentPage < lastPage;
  TaxPaymentDetailModel? get detail      => _detail;
  bool get isLoadingDetail               => _isLoadingDetail;
  String? get detailError                => _detailError;
  bool get isSaving                      => _isSaving;
  String? get formError                  => _formError;
  String? get successMessage             => _successMessage;
  String? get savedEncryption            => _savedEncryption;

  Future<void> fetchList({String? status}) async {
    _statusFilter  = status;
    _isLoadingList = true;
    _listError     = null;
    notifyListeners();
    try {
      final all = <TaxPaymentModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page:    p,
          perPage: 100,
          status:  _statusFilter,
          search:  _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as TaxPaymentPaginationMeta;
        all.addAll(r['items'] as List<TaxPaymentModel>);
        if (p >= meta.lastPage) break;
        p++;
      }
      _all = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _msg(e);
      _all       = [];
      _filtered  = [];
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
        (t.transactionNumber?.toLowerCase().contains(q) ?? false) ||
        (t.customerName?.toLowerCase().contains(q) ?? false) ||
        (t.taxReferenceNumber?.toLowerCase().contains(q) ?? false)).toList();
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

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true;
    _detailError     = null;
    notifyListeners();
    try {
      _detail = await getDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail      = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<List<TaxTransactionOption>> searchTransactions(String term, {int? excludeId}) =>
      searchTransactionsUC(term, excludeId: excludeId);

  Future<bool> save(TaxPaymentFormModel f) => _run(
        () => saveTP(f),
        f.isEditMode ? 'Tax Payment updated' : 'Tax Payment saved as draft',
      );

  Future<bool> post(String enc) => _run(() => postTP(enc), 'Tax Payment posted');

  Future<bool> unpost(String enc) => _run(() => unpostTP(enc), 'Tax Payment returned to Draft');

  Future<bool> _run(Future<String> Function() action, String message) async {
    _isSaving       = true;
    _formError      = null;
    _successMessage = null;
    notifyListeners();
    try {
      _savedEncryption = await action();
      _successMessage  = message;
      await fetchList(status: _statusFilter);
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

  Future<bool> remove(String enc) async {
    _isSaving  = true;
    _formError = null;
    notifyListeners();
    try {
      await deleteTP(enc);
      _successMessage = 'Tax Payment deleted';
      await fetchList(status: _statusFilter);
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
    _detail          = null;
    _detailError     = null;
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e
      .toString()
      .replaceFirst('Exception:', '')
      .trim()
      .replaceFirst(RegExp(r'^(Save|Run|Confirm|Post|Unpost|Cancel|Delete) failed:\s*'), '');
}