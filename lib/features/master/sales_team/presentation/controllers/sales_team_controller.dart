import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/models/sales_team_models.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/domain/usecases/sales_team_usecases.dart';

class SalesTeamController extends ChangeNotifier {
  final GetSalesTeamList getSalesTeamList;
  final GetSalesTeamDetail getSalesTeamDetail;
  final GetSalesTeamFormOptions getFormOptions;
  final CreateSalesTeam createSalesTeam;
  final UpdateSalesTeam updateSalesTeam;
  final DeleteSalesTeam deleteSalesTeam;

  SalesTeamController({
    required this.getSalesTeamList,
    required this.getSalesTeamDetail,
    required this.getFormOptions,
    required this.createSalesTeam,
    required this.updateSalesTeam,
    required this.deleteSalesTeam,
  });

  List<SalesTeamModel> _allTeams = [];
  List<SalesTeamModel> _filteredTeams = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  SalesTeamDetailModel? _teamDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  SalesTeamDropdownData? _dropdownData;
  bool _isLoadingDropdown = false;
  bool _dropdownLoaded = false;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<SalesTeamModel> get teamList {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _filteredTeams.length);
    if (start >= _filteredTeams.length) return [];
    return _filteredTeams.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage =>
      (_filteredTeams.length / _perPage).ceil().clamp(1, 99999);
  int get total => _filteredTeams.length;
  bool get hasPrevPage => _currentPage > 1;
  bool get hasNextPage => _currentPage < lastPage;

  SalesTeamDetailModel? get teamDetail => _teamDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  SalesTeamDropdownData? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchTeamList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final List<SalesTeamModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result = await getSalesTeamList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as SalesTeamPaginationMeta;
        final items = result['items'] as List<SalesTeamModel>;
        all.addAll(items);
        if (fetchPage >= meta.lastPage) break;
        fetchPage++;
      }
      _allTeams = all;
      _applyFilter();
      _currentPage = 1;
    } catch (e) {
      _listError = _extractMessage(e);
      _allTeams = [];
      _filteredTeams = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredTeams = List.from(_allTeams);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredTeams = _allTeams.where((t) {
        return t.teamName.toLowerCase().contains(q) ||
            t.teamLeaderName.toLowerCase().contains(q) ||
            (t.description?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
  }

  void searchTeams(String query) {
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

  Future<void> fetchFormDropdownData({bool forceRefresh = false}) async {
    if (_dropdownLoaded && !forceRefresh) return;
    _isLoadingDropdown = true;
    notifyListeners();
    try {
      _dropdownData = await getFormOptions();
      _dropdownLoaded = true;
    } catch (e) {
      _dropdownData = null;
    } finally {
      _isLoadingDropdown = false;
      notifyListeners();
    }
  }

  Future<void> fetchTeamDetail(String encryption) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();
    try {
      _teamDetail = await getSalesTeamDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _teamDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveTeam(SalesTeamFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createSalesTeam(formData);
      _successMessage = 'Sales team created successfully';
      await fetchTeamList();
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editTeam(String encryption, SalesTeamFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updateSalesTeam(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Sales team updated successfully';
      await fetchTeamList();
      await fetchTeamDetail(newEncryption);
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> removeTeam(String encryption) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await deleteSalesTeam(encryption);
      _successMessage = 'Sales team deleted successfully';
      await fetchTeamList();
      if (teamList.isEmpty && _currentPage > 1) _currentPage--;
      return true;
    } catch (e) {
      _formError = _extractMessage(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void resetDetailState() {
    _teamDetail = null;
    _detailError = null;
    _updatedEncryption = null;
    notifyListeners();
  }

  void clearMessages() {
    _successMessage = null;
    _formError = null;
    notifyListeners();
  }

  String _extractMessage(dynamic error) =>
      error.toString().replaceFirst('Exception: ', '');
}