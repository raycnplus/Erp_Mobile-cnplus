import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/models/purchase_team_models.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/domain/usecases/purchase_team_usecases.dart';

class PurchaseTeamController extends ChangeNotifier {
  final GetPurchaseTeamList getPurchaseTeamList;
  final GetPurchaseTeamDetail getPurchaseTeamDetail;
  final GetPurchaseTeamFormOptions getFormOptions;
  final CreatePurchaseTeam createPurchaseTeam;
  final UpdatePurchaseTeam updatePurchaseTeam;
  final DeletePurchaseTeam deletePurchaseTeam;

  PurchaseTeamController({
    required this.getPurchaseTeamList,
    required this.getPurchaseTeamDetail,
    required this.getFormOptions,
    required this.createPurchaseTeam,
    required this.updatePurchaseTeam,
    required this.deletePurchaseTeam,
  });

  List<PurchaseTeamModel> _allTeams = [];
  List<PurchaseTeamModel> _filteredTeams = [];
  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;
  static const int _perPage = 15;
  String _searchQuery = '';

  PurchaseTeamDetailModel? _teamDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  PurchaseTeamDropdownData? _dropdownData;
  bool _isLoadingDropdown = false;
  bool _dropdownLoaded = false;
  String? _dropdownError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;
  String? _updatedEncryption;

  List<PurchaseTeamModel> get teamList {
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

  PurchaseTeamDetailModel? get teamDetail => _teamDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  PurchaseTeamDropdownData? get dropdownData => _dropdownData;
  bool get isLoadingDropdown => _isLoadingDropdown;
  String? get dropdownError => _dropdownError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchTeamList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();
    try {
      final List<PurchaseTeamModel> all = [];
      int fetchPage = 1;
      while (true) {
        final result = await getPurchaseTeamList(page: fetchPage, perPage: 100);
        final meta = result['meta'] as PurchaseTeamPaginationMeta;
        final items = result['items'] as List<PurchaseTeamModel>;
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
            t.teamLeader.toLowerCase().contains(q) ||
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
    _dropdownError = null;
    notifyListeners();
    try {
      _dropdownData = await getFormOptions();
      _dropdownLoaded = true;
    } catch (e) {
      _dropdownError = _extractMessage(e);
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
      _teamDetail = await getPurchaseTeamDetail(encryption);
    } catch (e) {
      _detailError = _extractMessage(e);
      _teamDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> saveTeam(PurchaseTeamFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();
    try {
      await createPurchaseTeam(formData);
      _successMessage = 'Purchase team created successfully';
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

  Future<bool> editTeam(String encryption, PurchaseTeamFormModel formData) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    _updatedEncryption = null;
    notifyListeners();
    try {
      final newEncryption = await updatePurchaseTeam(encryption, formData);
      _updatedEncryption = newEncryption;
      _successMessage = 'Purchase team updated successfully';
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
      await deletePurchaseTeam(encryption);
      _successMessage = 'Purchase team deleted successfully';
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