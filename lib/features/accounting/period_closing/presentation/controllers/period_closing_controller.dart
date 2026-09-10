import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/models/period_closing_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/domain/usecases/period_closing_usecases.dart';

class PeriodClosingController extends ChangeNotifier {
  final GetPeriodClosingList getList;
  final GetPeriodClosingDetail getDetail;
  final SavePeriodClosing savePC;
  final DeletePeriodClosing deletePC;
  final PostPeriodClosing postPC;
  final GetPeriodClosingBalanceDetail getBalanceDetail;

  PeriodClosingController({
    required this.getList,
    required this.getDetail,
    required this.savePC,
    required this.deletePC,
    required this.postPC,
    required this.getBalanceDetail,
  });

  List<PeriodClosingModel> _items = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  String? _statusFilter;
  String? _typeFilter;

  List<PeriodClosingModel> get items => _items;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < _lastPage;

  PeriodClosingDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  PeriodClosingDetailModel? get detail => _detail;
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

  bool _isLoadingBalance = false;
  String? _balanceError;
  List<PeriodClosingBalanceRow> _balanceRows = [];

  bool get isLoadingBalance => _isLoadingBalance;
  String? get balanceError => _balanceError;
  List<PeriodClosingBalanceRow> get balanceRows => _balanceRows;

  Future<void> fetchList({String? status, String? type, int page = 1}) async {
    _statusFilter = status;
    _typeFilter = type;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final r = await getList(page: page, perPage: 15, status: status, type: type);
      final meta = r['meta'] as PeriodClosingPaginationMeta;
      _items = r['items'] as List<PeriodClosingModel>;
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
    fetchList(status: _statusFilter, type: _typeFilter, page: p);
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

  Future<bool> save(PeriodClosingFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final saved = await savePC(f);
      _savedEncryption = saved.encryption;
      _successMessage = f.isEditMode ? 'Period closing updated' : 'Period closing created';
      await fetchList(status: _statusFilter, type: _typeFilter, page: _currentPage);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> post(String encryption) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await postPC(encryption);
      _successMessage = 'Period closing posted';
      await fetchList(status: _statusFilter, type: _typeFilter, page: _currentPage);
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

  Future<bool> remove(String encryption) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await deletePC(encryption);
      _successMessage = 'Period closing deleted';
      await fetchList(status: _statusFilter, type: _typeFilter, page: _currentPage);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> fetchBalanceDetail({required int year, String type = 'MONTHLY', int? month}) async {
    _isLoadingBalance = true;
    _balanceError = null;
    notifyListeners();

    try {
      _balanceRows = await getBalanceDetail(year: year, type: type, month: month);
    } catch (e) {
      _balanceError = _msg(e);
      _balanceRows = [];
    } finally {
      _isLoadingBalance = false;
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