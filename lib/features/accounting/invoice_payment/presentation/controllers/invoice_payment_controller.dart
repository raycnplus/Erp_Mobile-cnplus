import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/models/invoice_payment_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/domain/usecases/invoice_payment_usecases.dart';

class InvoicePaymentController extends ChangeNotifier {
  final GetInvoicePaymentList getList;
  final GetInvoicePaymentDetail getDetail;
  final GetInvoicePaymentFormOptions getFormOptions;
  final GetCustomerInvoices getCustomerInvoicesUC;
  final SaveInvoicePayment saveIP;
  final ConfirmInvoicePayment confirmIP;
  final PostInvoicePayment postIP;
  final UnpostInvoicePayment unpostIP;
  final CancelInvoicePayment cancelIP;
  final DeleteInvoicePayment deleteIP;
  final BulkConfirmInvoicePayments bulkConfirmIP;
  final BulkPostInvoicePayments bulkPostIP;

  InvoicePaymentController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.getCustomerInvoicesUC,
    required this.saveIP,
    required this.confirmIP,
    required this.postIP,
    required this.unpostIP,
    required this.cancelIP,
    required this.deleteIP,
    required this.bulkConfirmIP,
    required this.bulkPostIP,
  });

  static const int _perPage = 15;

  List<InvoicePaymentModel> _all = [];
  List<InvoicePaymentModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;
  String? _invoiceTypeFilter;

  InvoicePaymentDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  InvoicePaymentFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  final Set<int> _selectedIds = {};

  List<InvoicePaymentModel> get pageItems {
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

  InvoicePaymentDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  InvoicePaymentFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Set<int> get selectedIds => _selectedIds;

  Future<void> fetchList({String? status, String? invoiceType}) async {
    _statusFilter = status;
    _invoiceTypeFilter = invoiceType;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <InvoicePaymentModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          search: _searchQuery.isEmpty ? null : _searchQuery,
          status: _statusFilter,
          invoiceType: _invoiceTypeFilter,
        );
        final meta = r['meta'] as InvoicePaymentPaginationMeta;
        all.addAll(r['items'] as List<InvoicePaymentModel>);
        if (p >= meta.lastPage) break;
        p++;
      }
      _all = all;
      _applyFilter();
      _currentPage = 1;
      _selectedIds.clear();
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
        (t.customerName?.toLowerCase().contains(q) ?? false) ||
        (t.invoiceNumber?.toLowerCase().contains(q) ?? false)).toList();
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

  void toggleSelect(int idPayment) {
    if (_selectedIds.contains(idPayment)) {
      _selectedIds.remove(idPayment);
    } else {
      _selectedIds.add(idPayment);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
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

  Future<List<InvoiceOption>> getCustomerInvoices(int idCustomer, String invoiceType) =>
      getCustomerInvoicesUC(idCustomer, invoiceType);

  Future<bool> save(InvoicePaymentFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveIP(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? (f.isEditMode ? 'Payment updated successfully' : 'Payment created successfully');
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
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
      final result = await confirmIP(encryption);
      _successMessage = result['message']?.toString() ?? 'Payment confirmed successfully';
      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) _savedEncryption = newEncryption;
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
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
      final result = await postIP(encryption, journalTransactionDate: journalTransactionDate);
      _successMessage = result['message']?.toString() ?? 'Payment marked as Posted successfully';
      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) _savedEncryption = newEncryption;
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
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
      final result = await unpostIP(encryption);
      _successMessage = result['message']?.toString() ?? 'Payment successfully unposted';
      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) _savedEncryption = newEncryption;
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
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
      await cancelIP(encryption, reason);
      _successMessage = 'Payment cancelled successfully';
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
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
      await deleteIP(encryption);
      _successMessage = 'Payment deleted successfully';
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> bulkConfirmSelected() async {
    if (_selectedIds.isEmpty) return false;
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await bulkConfirmIP(_selectedIds.toList());
      _successMessage = result['message']?.toString() ?? 'Bulk confirm completed';
      _selectedIds.clear();
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
      return result['success'] == true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> bulkPostSelected({String? journalTransactionDate}) async {
    if (_selectedIds.isEmpty) return false;
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await bulkPostIP(_selectedIds.toList(), journalTransactionDate: journalTransactionDate);
      _successMessage = result['message']?.toString() ?? 'Bulk post completed';
      _selectedIds.clear();
      await fetchList(status: _statusFilter, invoiceType: _invoiceTypeFilter);
      return result['success'] == true;
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