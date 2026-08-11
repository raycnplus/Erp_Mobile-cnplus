import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/data/datasources/leave_quota_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/data/models/leave_quota_models.dart';

class LeaveQuotaController extends ChangeNotifier {
  final LeaveQuotaRemoteDataSource ds;

  LeaveQuotaController({
    required this.ds,
  });

  List<LeaveQuotaModel> _all = [];
  List<LeaveQuotaModel> _filtered = [];

  bool _isLoadingList = false;
  String? _listError;

  int _currentPage = 1;

  static const int _perPage = 15;

  String _searchQuery = '';
  String _period = DateTime.now().year.toString();
  String _showType = 'all';

  List<LeaveHistoryModel> _history = [];

  bool _isLoadingHistory = false;
  String? _historyError;

  int _historyPage = 1;
  int _historyLastPage = 1;

  List<LeaveQuotaModel> get pageItems {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(
      0,
      _filtered.length,
    );

    if (start >= _filtered.length) {
      return [];
    }

    return _filtered.sublist(start, end);
  }

  bool get isLoadingList => _isLoadingList;

  String? get listError => _listError;

  int get currentPage => _currentPage;

  int get lastPage =>
      (_filtered.length / _perPage)
          .ceil()
          .clamp(1, 99999);

  int get total => _filtered.length;

  bool get hasPrev => _currentPage > 1;

  bool get hasNext => _currentPage < lastPage;

  String get period => _period;

  String get showType => _showType;

  List<LeaveHistoryModel> get history => _history;

  bool get isLoadingHistory => _isLoadingHistory;

  String? get historyError => _historyError;

  int get historyPage => _historyPage;

  int get historyLastPage => _historyLastPage;

  Future<void> fetchList({
    String? period,
    String? showType,
  }) async {
    if (period != null) {
      _period = period;
    }

    if (showType != null) {
      _showType = showType;
    }

    _isLoadingList = true;
    _listError = null;

    notifyListeners();

    try {
      final all = <LeaveQuotaModel>[];
      int page = 1;

      while (true) {
        final result = await ds.getList(
          page: page,
          perPage: 100,
          period: _period,
          showType: _showType,
        );

        final meta =
            result['meta']
                as LeaveQuotaPaginationMeta;

        all.addAll(
          result['items']
              as List<LeaveQuotaModel>,
        );

        if (page >= meta.lastPage) {
          break;
        }

        page++;
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

    final query = _searchQuery.toLowerCase();

    _filtered =
        _all.where((item) {
          return item.employeeName
                  .toLowerCase()
                  .contains(query) ||
              item.leaveTypeName
                  .toLowerCase()
                  .contains(query);
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

  void goToPage(int page) {
    if (page < 1 || page > lastPage) {
      return;
    }

    _currentPage = page;

    notifyListeners();
  }

  void nextPage() {
    goToPage(_currentPage + 1);
  }

  void prevPage() {
    goToPage(_currentPage - 1);
  }

  Future<void> fetchHistory(
    String empEnc,
    int leaveTypeId, {
    int page = 1,
    String? period,
  }) async {
    _isLoadingHistory = true;
    _historyError = null;

    notifyListeners();

    try {
      final result = await ds.getHistory(
        empEnc,
        leaveTypeId,
        page: page,
        perPage: 15,
        period: period ?? _period,
      );

      _history =
          result['items']
              as List<LeaveHistoryModel>;

      final meta =
          result['meta']
              as LeaveQuotaPaginationMeta;

      _historyPage = meta.currentPage;
      _historyLastPage = meta.lastPage;
    } catch (e) {
      _historyError = _msg(e);

      _history = [];
    } finally {
      _isLoadingHistory = false;

      notifyListeners();
    }
  }

  String _msg(dynamic error) {
    return error
        .toString()
        .replaceFirst('Exception:', '')
        .trim();
  }
}