import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/models/transfer_out_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/domain/usecases/transfer_out_usecases.dart';

class TransferOutController extends ChangeNotifier {
  final GetTOList getList;
  final GetTODetail getDetail;
  final SaveTransferOut saveTO;
  final ValidateTransferOut validateTO;

  TransferOutController({
    required this.getList,
    required this.getDetail,
    required this.saveTO,
    required this.validateTO,
  });

  static const int _perPage = 15;

  List<TransferOutModel> _all = [];
  List<TransferOutModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;

  TransferOutDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  bool _hasBackorder = false;

  List<TransferOutModel> get pageItems {
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

  TransferOutDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  bool get hasBackorder => _hasBackorder;

  Future<void> fetchList({String? status}) async {
    _statusFilter = status;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <TransferOutModel>[];
      int p = 1;

      while (true) {
        final r = await getList(
          page: p,
          perPage: 100,
          status: _statusFilter,
          search: _searchQuery.isEmpty ? null : _searchQuery,
        );
        final meta = r['meta'] as TransferOutPaginationMeta;
        all.addAll(r['items'] as List<TransferOutModel>);
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

  Future<bool> save(String encryption, TransferOutFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await saveTO(encryption, f);
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

  Future<bool> validate(String encryption, TransferOutFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _hasBackorder = false;
    notifyListeners();

    try {
      final result = await validateTO(encryption, f);
      _hasBackorder = result['has_backorder'] == true;
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
    _hasBackorder = false;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}