import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/sales/ppn_report/data/models/ppn_report_models.dart';

import 'package:erp_mobile_cnplus/features/sales/ppn_report/domain/usecases/ppn_report_usecases.dart';

class PPNReportController extends ChangeNotifier {
  final GetPPNReportList getPPNReportList;

  PPNReportController({
    required this.getPPNReportList,
  });

  // ============================================================
  // LIST STATE
  // ============================================================

  List<PPNReportModel> _list = [];

  bool _isLoadingList = false;

  String? _listError;

  PPNReportSummary? _summary;

  bool _hasFetchedOnce = false;

  // ============================================================
  // PAGINATION
  // ============================================================

  int _currentPage = 1;

  int _lastPage = 1;

  int _total = 0;

  static const int _perPage = 15;

  // ============================================================
  // FILTER
  // ============================================================

  String _reference = '';

  String _taxWithholder = '';

  DateTime? _dateFrom;

  DateTime? _dateTo;

  // ============================================================
  // SORT
  // ============================================================

  String _sortField = 'date';

  String _sortDirection = 'desc';

  // ============================================================
  // GETTERS
  // ============================================================

  List<PPNReportModel> get list => _list;

  bool get isLoadingList => _isLoadingList;

  String? get listError => _listError;

  PPNReportSummary? get summary => _summary;

  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;

  int get lastPage => _lastPage;

  int get total => _total;

  bool get hasPrevPage =>
      _currentPage > 1;

  bool get hasNextPage =>
      _currentPage < _lastPage;

  String get reference => _reference;

  String get taxWithholder =>
      _taxWithholder;

  DateTime? get dateFrom =>
      _dateFrom;

  DateTime? get dateTo =>
      _dateTo;

  String get sortField =>
      _sortField;

  String get sortDirection =>
      _sortDirection;

  bool get hasActiveFilter =>
      _reference.isNotEmpty ||
      _taxWithholder.isNotEmpty ||
      _dateFrom != null ||
      _dateTo != null;

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // FETCH LIST
  // ============================================================

  Future<void> fetchList({
    int? page,
  }) async {
    _isLoadingList = true;

    _listError = null;

    _hasFetchedOnce = true;

    notifyListeners();

    try {
      final result = await getPPNReportList(
        page: page ?? _currentPage,
        perPage: _perPage,

        reference: _reference,

        taxWithholder:
            _taxWithholder,

        dateFrom: _dateFrom != null
            ? _formatDate(_dateFrom!)
            : null,

        dateTo: _dateTo != null
            ? _formatDate(_dateTo!)
            : null,

        sortField: _sortField,

        sortDirection:
            _sortDirection,
      );

      final meta =
          result['meta']
              as PPNReportPaginationMeta;

      _list =
          result['items']
              as List<PPNReportModel>;

      _summary =
          result['summary']
              as PPNReportSummary;

      _currentPage =
          meta.currentPage;

      _lastPage =
          meta.lastPage;

      _total =
          meta.total;
    } catch (e) {
      _listError =
          _extractMessage(e);

      _list = [];
    } finally {
      _isLoadingList = false;

      notifyListeners();
    }
  }

  // ============================================================
  // SET FILTER
  // ============================================================

  void setReference(
    String value,
  ) {
    _reference = value;
  }

  void setTaxWithholder(
    String value,
  ) {
    _taxWithholder = value;
  }

  void setDateRange(
    DateTime? from,
    DateTime? to,
  ) {
    _dateFrom = from;

    _dateTo = to;
  }

  // ============================================================
  // SORT
  // ============================================================

  void setSort({
    required String field,
    required String direction,
  }) {
    _sortField = field;

    _sortDirection =
        direction == 'asc'
            ? 'asc'
            : 'desc';

    notifyListeners();
  }

  // ============================================================
  // APPLY FILTER
  // ============================================================

  void applyFilter() {
    _currentPage = 1;

    fetchList(
      page: 1,
    );
  }

  // ============================================================
  // RESET FILTER
  // ============================================================

  void resetFilter() {
    _reference = '';

    _taxWithholder = '';

    _dateFrom = null;

    _dateTo = null;

    _sortField = 'date';

    _sortDirection = 'desc';

    _currentPage = 1;

    fetchList(
      page: 1,
    );
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  void goToPage(
    int page,
  ) {
    if (page < 1 ||
        page > _lastPage ||
        page == _currentPage) {
      return;
    }

    fetchList(
      page: page,
    );
  }

  void nextPage() {
    goToPage(
      _currentPage + 1,
    );
  }

  void prevPage() {
    goToPage(
      _currentPage - 1,
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _extractMessage(
    dynamic error,
  ) =>
      error
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
}