import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/models/salespersons_report_models.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/domain/usecases/salespersons_report_usecases.dart';

class SalespersonsReportController extends ChangeNotifier {
  final GetSalespersonsReportList getSalespersonsReportList;

  SalespersonsReportController({
    required this.getSalespersonsReportList,
  });

  List<SalespersonsReportModel> _list = [];

  bool _isLoadingList = false;
  String? _listError;

  bool _hasFetchedOnce = false;

  String _searchQuery = '';

  DateTime? _dateFrom;
  DateTime? _dateTo;

  // ============================================================
  // SALESPERSON FILTER
  // ============================================================

  // Kita simpan nama salesperson sebagai identity UI.
  //
  // Alasan:
  // idUser dari endpoint report bisa saja sama untuk beberapa
  // salesperson sehingga tidak aman dijadikan identity tunggal.
  List<String> _selectedSalespersonNames = [];

  // ============================================================
  // SALESPERSON OPTIONS
  // ============================================================

  List<SalespersonOption> _salespersonOptions = [];

  bool _isLoadingOptions = false;
  String? _optionsError;

  // ============================================================
  // GETTERS
  // ============================================================

  List<SalespersonsReportModel> get list => _list;

  bool get isLoadingList => _isLoadingList;

  String? get listError => _listError;

  bool get hasFetchedOnce => _hasFetchedOnce;

  DateTime? get dateFrom => _dateFrom;

  DateTime? get dateTo => _dateTo;

  List<String> get selectedSalespersonNames =>
      List.unmodifiable(_selectedSalespersonNames);

  List<SalespersonOption> get salespersonOptions =>
      List.unmodifiable(_salespersonOptions);

  bool get isLoadingOptions => _isLoadingOptions;

  String? get optionsError => _optionsError;

  bool get hasActiveFilter =>
      _dateFrom != null ||
      _dateTo != null ||
      _selectedSalespersonNames.isNotEmpty;

  // ============================================================
  // FILTERED LIST
  // ============================================================

  List<SalespersonsReportModel> get filteredList {
    Iterable<SalespersonsReportModel> result = _list;

    // ----------------------------------------------------------
    // FILTER SALESPERSON
    // ----------------------------------------------------------
    if (_selectedSalespersonNames.isNotEmpty) {
      final selectedNames = _selectedSalespersonNames
          .map((e) => e.trim().toLowerCase())
          .toSet();

      result = result.where((e) {
        return selectedNames.contains(
          e.salespersonName.trim().toLowerCase(),
        );
      });
    }

    // ----------------------------------------------------------
    // SEARCH
    // ----------------------------------------------------------
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();

      result = result.where(
        (e) => e.salespersonName.toLowerCase().contains(q),
      );
    }

    return result.toList();
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // FETCH SALESPERSON OPTIONS
  // ============================================================

  Future<void> fetchFilterOptions() async {
    _isLoadingOptions = true;
    _optionsError = null;

    notifyListeners();

    try {
      final result = await getSalespersonsReportList();

      // Dedupe berdasarkan nama salesperson.
      //
      // Jangan gunakan idUser sebagai key karena kasusmu
      // menunjukkan beberapa salesperson bisa memiliki idUser
      // yang sama dari response report.
      final Map<String, SalespersonOption> uniqueOptions = {};

      for (final e in result) {
        final name = e.salespersonName.trim();

        if (name.isEmpty) {
          continue;
        }

        final key = name.toLowerCase();

        uniqueOptions.putIfAbsent(
          key,
          () => SalespersonOption(
            idUser: e.idUser,
            salespersonName: name,
          ),
        );
      }

      _salespersonOptions = uniqueOptions.values.toList();

      // Urutkan berdasarkan nama
      _salespersonOptions.sort(
        (a, b) => a.salespersonName.toLowerCase().compareTo(
              b.salespersonName.toLowerCase(),
            ),
      );
    } catch (e) {
      _optionsError = e.toString();
      _salespersonOptions = [];
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  // ============================================================
  // FETCH REPORT LIST
  // ============================================================

  Future<void> fetchList() async {
    _isLoadingList = true;
    _listError = null;
    _hasFetchedOnce = true;

    notifyListeners();

    try {
      // Salesperson TIDAK dikirim ke backend.
      //
      // Backend report akan mengambil data berdasarkan tanggal,
      // kemudian salesperson difilter melalui filteredList.
      _list = await getSalespersonsReportList(
        dateFrom: _dateFrom != null
            ? _formatDate(_dateFrom!)
            : null,
        dateTo: _dateTo != null
            ? _formatDate(_dateTo!)
            : null,
        idSalesperson: null,
      );
    } catch (e) {
      _listError = _extractMessage(e);
      _list = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchList(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // ============================================================
  // DATE
  // ============================================================

  void setDateRange(DateTime? from, DateTime? to) {
    _dateFrom = from;
    _dateTo = to;

    notifyListeners();
  }

  // ============================================================
  // SALESPERSON SELECTION
  // ============================================================

  void toggleSalesperson(String salespersonName) {
    final name = salespersonName.trim();

    if (name.isEmpty) {
      return;
    }

    final exists = _selectedSalespersonNames.any(
      (e) => e.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      _selectedSalespersonNames =
          List.of(_selectedSalespersonNames)
            ..removeWhere(
              (e) => e.toLowerCase() == name.toLowerCase(),
            );
    } else {
      _selectedSalespersonNames =
          List.of(_selectedSalespersonNames)
            ..add(name);
    }

    notifyListeners();
  }

  void setSelectedSalespersons(List<String> names) {
    _selectedSalespersonNames = names
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    notifyListeners();
  }

  void clearSelectedSalespersons() {
    _selectedSalespersonNames = [];
    notifyListeners();
  }

  // ============================================================
  // APPLY / RESET
  // ============================================================

  void applyFilter() {
    fetchList();
  }

  void resetFilter() {
    _dateFrom = null;
    _dateTo = null;
    _selectedSalespersonNames = [];

    fetchList();
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _extractMessage(dynamic error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}