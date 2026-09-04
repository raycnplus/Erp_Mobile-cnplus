import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/sales/pph_report/data/models/pph_report_models.dart';

import 'package:erp_mobile_cnplus/features/sales/pph_report/domain/usecases/pph_report_usecases.dart';

class PPHReportController extends ChangeNotifier {
  final GetPPHReportList getPPHReportList;

  PPHReportController({
    required this.getPPHReportList,
  });

  // ============================================================
  // LIST STATE
  // ============================================================

  List<PPHReportModel> _list = [];

  bool _isLoadingList = false;

  String? _listError;

  PPHReportSummary? _summary;

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

  String _paymentNumber = '';

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

  List<PPHReportModel> get list => _list;

  bool get isLoadingList => _isLoadingList;

  String? get listError => _listError;

  PPHReportSummary? get summary => _summary;

  bool get hasFetchedOnce => _hasFetchedOnce;

  int get currentPage => _currentPage;

  int get lastPage => _lastPage;

  int get total => _total;

  bool get hasPrevPage =>
      _currentPage > 1;

  bool get hasNextPage =>
      _currentPage < _lastPage;

  String get reference => _reference;

  String get paymentNumber =>
      _paymentNumber;

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
      _paymentNumber.isNotEmpty ||
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
      final result = await getPPHReportList(
        page: page ?? _currentPage,
        perPage: _perPage,

        reference:
            _reference,

        paymentNumber:
            _paymentNumber,

        taxWithholder:
            _taxWithholder,

        dateFrom:
            _dateFrom != null
                ? _formatDate(
                    _dateFrom!,
                  )
                : null,

        dateTo:
            _dateTo != null
                ? _formatDate(
                    _dateTo!,
                  )
                : null,

        sortField:
            _sortField,

        sortDirection:
            _sortDirection,
      );

      final meta =
          result['meta']
              as PPHReportPaginationMeta;

      _list =
          result['items']
              as List<PPHReportModel>;

      _summary =
          result['summary']
              as PPHReportSummary;

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
  // SEARCH
  // ============================================================

  void searchList(
    String query,
  ) {
    _reference = query.trim();

    _currentPage = 1;

    fetchList(
      page: 1,
    );
  }

  void clearSearch() {
    _reference = '';

    _currentPage = 1;

    if (_hasFetchedOnce) {
      fetchList(
        page: 1,
      );
    }
  }

  // ============================================================
  // FILTER
  // ============================================================

  void setReference(
    String value,
  ) {
    _reference = value;
  }

  void setPaymentNumber(
    String value,
  ) {
    _paymentNumber = value;
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

    _paymentNumber = '';

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