import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/domain/usecases/coa_usecases.dart';

class CoaController extends ChangeNotifier {
  final GetCoaList getCoaList;
  final GetCoaDetail getCoaDetail;
  final GetCoaFormOptions getFormOptions;
  final GetCoaAutonumber getAutonumber;
  final CheckCoaChildren checkChildren;
  final CreateCoa createCoa;
  final UpdateCoa updateCoa;
  final DeleteCoa deleteCoa;

  CoaController({
    required this.getCoaList,
    required this.getCoaDetail,
    required this.getFormOptions,
    required this.getAutonumber,
    required this.checkChildren,
    required this.createCoa,
    required this.updateCoa,
    required this.deleteCoa,
  });

  List<CoaModel> _all = [], _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  String _searchQuery = '';

  CoaDetailModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  CoaFormOptions? _formOptions;
  bool _isLoadingFormOptions = false;
  bool _formOptionsLoaded = false;

  int? _autonumber;
  bool _isLoadingAutonumber = false;

  bool _isSaving = false;
  String? _formError, _successMessage, _updatedEncryption;

  List<CoaModel> get items => _filtered;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get total => _filtered.length;

  CoaDetailModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  CoaFormOptions? get formOptions => _formOptions;
  bool get isLoadingFormOptions => _isLoadingFormOptions;

  int? get autonumber => _autonumber;
  bool get isLoadingAutonumber => _isLoadingAutonumber;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;
  String? get updatedEncryption => _updatedEncryption;

  Future<void> fetchList() async {
    _isLoadingList = true; _listError = null; notifyListeners();
    try {
      _all = await getCoaList();
      _applyFilter();
    } catch (e) { _listError = _msg(e); _all = []; _filtered = []; }
    finally { _isLoadingList = false; notifyListeners(); }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) { _filtered = List.from(_all); return; }
    final q = _searchQuery.toLowerCase();
    _filtered = _all.where((c) =>
      c.coaNumber.toLowerCase().contains(q) ||
      c.coaName.toLowerCase().contains(q)
    ).toList();
  }

  void search(String query) {
    _searchQuery = query.trim();
    _applyFilter();
    notifyListeners();
  }

  void clearSearch() { _searchQuery = ''; _applyFilter(); notifyListeners(); }

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_formOptionsLoaded && !forceRefresh) return;
    _isLoadingFormOptions = true; notifyListeners();
    try { _formOptions = await getFormOptions(); _formOptionsLoaded = true; }
    catch (e) { _formOptions = null; }
    finally { _isLoadingFormOptions = false; notifyListeners(); }
  }

  Future<void> fetchAutonumber({int? parentId, String? isHeader}) async {
    _isLoadingAutonumber = true; _autonumber = null; notifyListeners();
    try { _autonumber = await getAutonumber(parentId: parentId, isHeader: isHeader); }
    catch (e) { _autonumber = null; }
    finally { _isLoadingAutonumber = false; notifyListeners(); }
  }

  Future<void> fetchDetail(String enc) async {
    _isLoadingDetail = true; _detailError = null; notifyListeners();
    try { _detail = await getCoaDetail(enc); }
    catch (e) { _detailError = _msg(e); _detail = null; }
    finally { _isLoadingDetail = false; notifyListeners(); }
  }

  Future<bool> checkHasChildren(String enc) async {
    try { return await checkChildren(enc); }
    catch (e) { return false; }
  }

  Future<bool> save(CoaFormModel f) async {
    _isSaving = true; _formError = null; _successMessage = null; notifyListeners();
    try { await createCoa(f); _successMessage = 'COA created successfully'; await fetchList(); return true; }
    catch (e) { _formError = _msg(e); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  Future<bool> edit(String enc, CoaFormModel f) async {
    _isSaving = true; _formError = null; _successMessage = null; _updatedEncryption = null; notifyListeners();
    try {
      final ne = await updateCoa(enc, f);
      _updatedEncryption = ne; _successMessage = 'COA updated successfully';
      await fetchList(); await fetchDetail(ne); return true;
    } catch (e) { _formError = _msg(e); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  Future<bool> remove(String enc) async {
    _isSaving = true; _formError = null; _successMessage = null; notifyListeners();
    try { await deleteCoa(enc); _successMessage = 'COA deleted successfully'; await fetchList(); return true; }
    catch (e) { _formError = _msg(e); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  void resetDetailState() { _detail = null; _detailError = null; _updatedEncryption = null; _autonumber = null; notifyListeners(); }
  String _msg(dynamic e) => e.toString().replaceFirst('Exception: ', '');
}