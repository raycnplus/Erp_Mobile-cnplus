import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/models/transfer_in_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/domain/usecases/transfer_in_usecases.dart';

class TransferInController extends ChangeNotifier {
  final GetTIList getList;
  final GetTIDetail getDetail;
  final SaveTransferIn saveTI;
  final ValidateTransferIn validateTI;

  TransferInController({
    required this.getList,
    required this.getDetail,
    required this.saveTI,
    required this.validateTI,
  });

  static const int _perPage = 15;

  List<TransferInModel> _all = [];
  List<TransferInModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  TransferInDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  bool _hasDiscrepancy = false;

  List<TransferInModel> get pageItems {
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

  TransferInDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  bool get hasDiscrepancy => _hasDiscrepancy;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <TransferInModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as TransferInPaginationMeta;
        all.addAll(r['items'] as List<TransferInModel>);
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
    _filtered = _all.where((t) {
      return (t.reference?.toLowerCase().contains(q) ?? false) ||
          (t.sourceDocument?.toLowerCase().contains(q) ?? false) ||
          (t.sourceLocationName?.toLowerCase().contains(q) ?? false) ||
          (t.destinationLocationName?.toLowerCase().contains(q) ?? false);
    }).toList();
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

  Future<bool> save(String encryption, TransferInFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await saveTI(encryption, f);
      _successMessage = result['message']?.toString() ?? 'Saved successfully';
      await fetchDetail(encryption);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> validate(String encryption, TransferInFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _hasDiscrepancy = false;
    notifyListeners();

    try {
      final result = await validateTI(encryption, f);
      _hasDiscrepancy = result['has_discrepancy'] == true;
      _successMessage = result['message']?.toString() ?? 'Validated successfully';
      await fetchList(status: _statusFilter);
      await fetchDetail(encryption);
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
    _hasDiscrepancy = false;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}