import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/models/bill_payment_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/domain/usecases/bill_payment_usecases.dart';

class BillPaymentController extends ChangeNotifier {
  final GetBillPaymentList getList;
  final GetBillPaymentDetail getDetail;
  final GetBillPaymentFormOptions getFormOptions;
  final GetPayableBills getPayableBillsUC;
  final SaveBillPayment saveBP;
  final ConfirmBillPayment confirmBP;
  final PostBillPayment postBP;
  final UnpostBillPayment unpostBP;
  final CancelBillPayment cancelBP;
  final DeleteBillPayment deleteBP;

  BillPaymentController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.getPayableBillsUC,
    required this.saveBP,
    required this.confirmBP,
    required this.postBP,
    required this.unpostBP,
    required this.cancelBP,
    required this.deleteBP,
  });

  static const int _perPage = 15;

  List<BillPaymentModel> _all = [];
  List<BillPaymentModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  BillPaymentDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  BillPaymentFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<BillPaymentModel> get pageItems {
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

  BillPaymentDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  BillPaymentFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <BillPaymentModel>[];
      int p = 1;
      while (true) {
        final r = await getList(page: p, perPage: 100, search: _searchQuery.isEmpty ? null : _searchQuery, status: _statusFilter);
        final meta = r['meta'] as BillPaymentPaginationMeta;
        all.addAll(r['items'] as List<BillPaymentModel>);
        if (p >= meta.lastPage) break;
        p++;
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
    final q = _searchQuery.toLowerCase();
    _filtered = _all.where((t) =>
        (t.paymentNumber?.toLowerCase().contains(q) ?? false) ||
        (t.vendorName?.toLowerCase().contains(q) ?? false) ||
        (t.billNumber?.toLowerCase().contains(q) ?? false)).toList();
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

  Future<List<BillOption>> getPayableBills(int idVendor) => getPayableBillsUC(idVendor);

  Future<bool> save(BillPaymentFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveBP(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? (f.isEditMode ? 'Payment updated successfully' : 'Payment created successfully');
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

  Future<bool> confirm(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await confirmBP(encryption);
      _successMessage = result['message']?.toString() ?? 'Payment confirmed successfully';
      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) _savedEncryption = newEncryption;
      await fetchList(status: _statusFilter);
      await fetchDetail(newEncryption ?? encryption);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> post(String encryption, {String? journalTransactionDate}) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await postBP(encryption, journalTransactionDate: journalTransactionDate);
      _successMessage = result['message']?.toString() ?? 'Payment marked as Posted successfully';
      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) _savedEncryption = newEncryption;
      await fetchList(status: _statusFilter);
      await fetchDetail(newEncryption ?? encryption);
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
    _successMessage = null;
    notifyListeners();
    try {
      final result = await unpostBP(encryption);
      _successMessage = result['message']?.toString() ?? 'Payment successfully unposted';
      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) _savedEncryption = newEncryption;
      await fetchList(status: _statusFilter);
      await fetchDetail(newEncryption ?? encryption);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> cancel(String encryption, String reason) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();
    try {
      await cancelBP(encryption, reason);
      _successMessage = 'Payment cancelled successfully';
      await fetchList(status: _statusFilter);
      if (_detail != null) await fetchDetail(_detail!.encryption);
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
      await deleteBP(encryption);
      _successMessage = 'Payment deleted successfully';
      await fetchList(status: _statusFilter);
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
    _savedEncryption = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}