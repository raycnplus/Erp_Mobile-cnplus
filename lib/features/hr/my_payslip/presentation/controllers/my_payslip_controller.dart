import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/models/my_payslip_models.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/domain/usecases/my_payslip_usecases.dart';

enum MyPaySlipStatus {
  initial,
  loading,
  loaded,
  error,
}

class MyPaySlipController
    extends ChangeNotifier {
  final GetMyPaySlipList getMyPaySlipList;

  MyPaySlipController({
    required this.getMyPaySlipList,
  });

  MyPaySlipStatus _status =
      MyPaySlipStatus.initial;

  String? _errorMessage;

  List<MyPaySlipModel> _items = [];

  MyPaySlipPagination? _pagination;

  int _currentPage = 1;

  final int _perPage = 10;

  String _searchQuery = '';

  String? _selectedStatus;

  int? _selectedYear;

  bool _hasFetchedOnce = false;

  // ============================================================
  // GETTERS
  // ============================================================

  MyPaySlipStatus get status => _status;

  String? get errorMessage =>
      _errorMessage;

  List<MyPaySlipModel> get items =>
      _items;

  MyPaySlipPagination? get pagination =>
      _pagination;

  int get currentPage =>
      _currentPage;

  int get perPage =>
      _perPage;

  String get searchQuery =>
      _searchQuery;

  String? get selectedStatus =>
      _selectedStatus;

  int? get selectedYear =>
      _selectedYear;

  bool get isLoading =>
      _status == MyPaySlipStatus.loading;

  bool get hasData =>
      _items.isNotEmpty;

  bool get hasFetchedOnce =>
      _hasFetchedOnce;

  bool get hasActiveFilter =>
      _selectedStatus != null ||
      _selectedYear != null;

  // ============================================================
  // FETCH LIST
  // ============================================================

  Future<void> fetchList({
    int page = 1,
  }) async {
    _currentPage = page;

    _status =
        MyPaySlipStatus.loading;

    _errorMessage = null;

    notifyListeners();

    try {
      final response =
          await getMyPaySlipList(
        page: _currentPage,
        perPage: _perPage,
        search: _searchQuery,
        status: _selectedStatus,
        year: _selectedYear,
      );

      _items = response.data;

      _pagination =
          response.pagination;

      _hasFetchedOnce = true;

      _status =
          MyPaySlipStatus.loaded;
    } catch (e) {
      _status =
          MyPaySlipStatus.error;

      _errorMessage = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      notifyListeners();
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void setSearch(String value) {
    _searchQuery = value;
  }

  Future<void> searchList(
    String value,
  ) async {
    _searchQuery = value.trim();

    await fetchList(
      page: 1,
    );
  }

  void clearSearch() {
    _searchQuery = '';

    fetchList(
      page: 1,
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  void setStatus(String? status) {
    _selectedStatus = status;
  }

  // ============================================================
  // YEAR
  // ============================================================

  void setYear(int? year) {
    _selectedYear = year;
  }

  // ============================================================
  // FILTER
  // ============================================================

  Future<void> applyFilter() async {
    await fetchList(
      page: 1,
    );
  }

  void resetFilter() {
    _selectedStatus = null;
    _selectedYear = null;

    fetchList(
      page: 1,
    );
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  Future<void> nextPage() async {
    final pagination = _pagination;

    if (pagination == null) {
      return;
    }

    if (_currentPage >=
        pagination.lastPage) {
      return;
    }

    await fetchList(
      page: _currentPage + 1,
    );
  }

  Future<void> previousPage() async {
    if (_currentPage <= 1) {
      return;
    }

    await fetchList(
      page: _currentPage - 1,
    );
  }

  Future<void> goToPage(
    int page,
  ) async {
    final pagination = _pagination;

    if (pagination == null) {
      return;
    }

    if (page < 1 ||
        page > pagination.lastPage) {
      return;
    }

    await fetchList(
      page: page,
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() {
    return fetchList(
      page: _currentPage,
    );
  }
}