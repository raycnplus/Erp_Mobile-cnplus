import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/models/national_holiday_models.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/domain/usecases/national_holiday_usecases.dart';

class NationalHolidayController extends ChangeNotifier {
  final GetNationalHolidayList getHolidayList;
  final GetNationalHolidayDetail getHolidayDetail;
  final CreateNationalHoliday createHoliday;
  final UpdateNationalHoliday updateHoliday;
  final DeleteNationalHoliday deleteHoliday;

  NationalHolidayController({
    required this.getHolidayList,
    required this.getHolidayDetail,
    required this.createHoliday,
    required this.updateHoliday,
    required this.deleteHoliday,
  });

  List<NationalHolidayModel> _all = [];
  List<NationalHolidayModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  NationalHolidayDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<NationalHolidayModel> get pageItems {
    final s = (_currentPage - 1) * _perPage;
    final e = (s + _perPage).clamp(0, _filtered.length);
    if (s >= _filtered.length) return [];
    return _filtered.sublist(s, e);
  }

  List<NationalHolidayModel> get itemList => pageItems;

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => (_filtered.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filtered.length;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < lastPage;
  bool get hasPrevPage => hasPrev;
  bool get hasNextPage => hasNext;

  NationalHolidayDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <NationalHolidayModel>[];
      int p = 1;

      while (true) {
        final r = await getHolidayList(page: p, perPage: 100);
        final meta = r['meta'] as NationalHolidayPaginationMeta;
        all.addAll(r['items'] as List<NationalHolidayModel>);
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
      return t.holidayName.toLowerCase().contains(q) || t.holidayDate.contains(q);
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
      _detail = await getHolidayDetail(enc);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(NationalHolidayFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await createHoliday(f);
      _successMessage = 'Holiday created successfully';
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

  Future<bool> edit(String enc, NationalHolidayFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();

    try {
      final ne = await updateHoliday(enc, f);
      _updatedEncryption = ne;
      _successMessage = 'Holiday updated successfully';
      await fetchList();
      await fetchDetail(ne);
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
      await deleteHoliday(enc);
      _successMessage = 'Holiday deleted successfully';
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

  void resetDetail() => resetDetailState();

  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}