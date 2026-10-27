import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/domain/usecases/printer_config_usecases.dart';

class PrinterConfigController extends ChangeNotifier {
  final GetPrinterConfigList getList;
  final GetPrinterConfigDetail getDetail;
  final SavePrinterConfig savePrinter;
  final DeletePrinterConfig deletePrinter;
  final SetDefaultPrinterConfig setDefaultPrinter;

  PrinterConfigController({
    required this.getList,
    required this.getDetail,
    required this.savePrinter,
    required this.deletePrinter,
    required this.setDefaultPrinter,
  });

  static const int _perPage = 15;

  List<PrinterConfigModel> _all = [];
  List<PrinterConfigModel> _filtered = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  String _searchQuery = '';

  PrinterConfigModel? _detail;
  bool _isLoadingDetail = false;
  String? _detailError;

  bool _isSaving = false;
  String? _formError;
  String? _successMessage;

  List<PrinterConfigModel> get pageItems {
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

  PrinterConfigModel? get detail => _detail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isSaving => _isSaving;
  String? get formError => _formError;
  String? get successMessage => _successMessage;

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final all = <PrinterConfigModel>[];
      int p = 1;

      while (true) {
        final r = await getList(page: p, perPage: 100, search: _searchQuery.isEmpty ? null : _searchQuery);
        final meta = r['meta'] as PrinterPaginationMeta;
        all.addAll(r['items'] as List<PrinterConfigModel>);
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
    _filtered = _all.where((p) {
      return p.printerName.toLowerCase().contains(q) ||
          (p.description?.toLowerCase().contains(q) ?? false);
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

  Future<void> fetchDetail(int id) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      _detail = await getDetail(id);
    } catch (e) {
      _detailError = _msg(e);
      _detail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<bool> save(PrinterConfigFormModel f) async {
    _isSaving = true;
    _formError = null;
    _successMessage = null;
    notifyListeners();

    try {
      await savePrinter(f);
      _successMessage = f.isEditMode ? 'Printer updated successfully' : 'Printer created successfully';
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

  Future<bool> remove(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await deletePrinter(id);
      _successMessage = 'Printer deleted successfully';
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

  Future<bool> setDefault(int id) async {
    _isSaving = true;
    _formError = null;
    notifyListeners();

    try {
      await setDefaultPrinter(id);
      _successMessage = 'Default printer updated';
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

  void resetDetailState() {
    _detail = null;
    _detailError = null;
    notifyListeners();
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}