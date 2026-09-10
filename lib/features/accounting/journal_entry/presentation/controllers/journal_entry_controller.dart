import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/models/journal_entry_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/domain/usecases/journal_entry_usecases.dart';

class JournalEntryController extends ChangeNotifier {
  final GetJournalEntryList getList;
  final GetJournalEntryDetail getDetail;
  final GetJournalEntryFormOptions getFormOptions;
  final SaveJournalEntry saveJE;
  final PostJournalEntry postJE;
  final UnpostJournalEntry unpostJE;
  final DeleteJournalEntry deleteJE;

  JournalEntryController({
    required this.getList,
    required this.getDetail,
    required this.getFormOptions,
    required this.saveJE,
    required this.postJE,
    required this.unpostJE,
    required this.deleteJE,
  });

  static const int _perPage = 15;

  List<JournalEntryModel> _all = [];
  List<JournalEntryModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _statusFilter;
  String? _startDate;
  String? _endDate;

  JournalEntryDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  JournalEntryFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;
  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _savedEncryption;

  List<JournalEntryModel> get pageItems {
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

  JournalEntryDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  JournalEntryFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get savedEncryption => _savedEncryption;

  Future<void> fetchList({String? status, String? startDate, String? endDate}) async {
    _statusFilter = status;
    _startDate = startDate;
    _endDate = endDate;
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final all = <JournalEntryModel>[];
      int p = 1;
      while (true) {
        final r = await getList(
          page: p, perPage: 100,
          search: _searchQuery.isEmpty ? null : _searchQuery,
          status: _statusFilter, startDate: _startDate, endDate: _endDate,
        );
        final meta = r['meta'] as JournalEntryPaginationMeta;
        all.addAll(r['items'] as List<JournalEntryModel>);
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

  Future<bool> save(JournalEntryFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await saveJE(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Journal Entry saved as draft';
      await fetchList(status: _statusFilter, startDate: _startDate, endDate: _endDate);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      if (_formError!.toLowerCase().contains('no query results')) {
        await fetchList(status: _statusFilter, startDate: _startDate, endDate: _endDate);
      }
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> post(JournalEntryFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      final result = await postJE(f);
      _savedEncryption = result['data']?['encryption']?.toString();
      _successMessage = result['message']?.toString() ?? 'Journal Entry posted successfully';
      await fetchList(status: _statusFilter, startDate: _startDate, endDate: _endDate);
      if (_savedEncryption?.isNotEmpty == true) await fetchDetail(_savedEncryption!);
      return true;
    } catch (e) {
      _formError = _msg(e);
      if (_formError!.toLowerCase().contains('no query results')) {
        await fetchList(status: _statusFilter, startDate: _startDate, endDate: _endDate);
      }
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
      final result = await unpostJE(encryption);
      _successMessage = result['message']?.toString() ?? 'Unposted';

      final newEncryption = result['data']?['encryption']?.toString();
      if (newEncryption != null && newEncryption.isNotEmpty) {
        _savedEncryption = newEncryption;
      }

      await fetchList(status: _statusFilter, startDate: _startDate, endDate: _endDate);

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
      await deleteJE(encryption);
      _successMessage = 'Journal Entry deleted';
      await fetchList(status: _statusFilter, startDate: _startDate, endDate: _endDate);
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