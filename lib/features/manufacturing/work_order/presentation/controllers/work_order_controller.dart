import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/models/work_order_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/domain/usecases/work_order_usecases.dart';

class WorkOrderController extends ChangeNotifier {
  final GetWOList getList;
  final GetWOFormOptions getFormOptions;
  final StartWorkOrder startWO;
  final PauseWorkOrder pauseWO;
  final ResumeWorkOrder resumeWO;
  final CompleteWorkOrder completeWO;

  WorkOrderController({
    required this.getList,
    required this.getFormOptions,
    required this.startWO,
    required this.pauseWO,
    required this.resumeWO,
    required this.completeWO,
  });

  List<WorkOrderModel> _items = [];
  bool _isLoadingList = false;
  String? _listError;
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  final WorkOrderFilter filter = WorkOrderFilter();

  WorkOrderFormOptions? _formOptions;
  bool _isLoadingOptions = false;
  bool _optionsLoaded = false;

  bool _isActing = false;
  String? _actionError;

  List<WorkOrderModel> get items => _items;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasPrev => _currentPage > 1;
  bool get hasNext => _currentPage < _lastPage;

  WorkOrderFormOptions? get formOptions => _formOptions;
  bool get isLoadingOptions => _isLoadingOptions;

  bool get isActing => _isActing;
  String? get actionError => _actionError;

  Future<void> fetchFormOptions({bool forceRefresh = false}) async {
    if (_optionsLoaded && !forceRefresh) return;
    _isLoadingOptions = true;
    notifyListeners();

    try {
      _formOptions = await getFormOptions();
      _optionsLoaded = true;
    } catch (_) {
      _formOptions = null;
    } finally {
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  Future<void> fetchList({int page = 1}) async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final r = await getList(page: page, perPage: 15, filter: filter);
      final meta = r['meta'] as WOPaginationMeta;
      _items = r['items'] as List<WorkOrderModel>;
      _currentPage = meta.currentPage;
      _lastPage = meta.lastPage;
      _total = meta.total;
    } catch (e) {
      _listError = _msg(e);
      _items = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  Future<void> applyFilter() => fetchList(page: 1);

  Future<void> resetFilter() {
    filter.clear();
    return fetchList(page: 1);
  }

  void goToPage(int p) {
    if (p < 1 || p > _lastPage || p == _currentPage) return;
    fetchList(page: p);
  }

  void nextPage() => goToPage(_currentPage + 1);
  void prevPage() => goToPage(_currentPage - 1);

  Future<bool> start(int trackingId) async {
    _isActing = true;
    _actionError = null;
    notifyListeners();

    try {
      await startWO(trackingId);
      await fetchList(page: _currentPage);
      return true;
    } catch (e) {
      _actionError = _msg(e);
      return false;
    } finally {
      _isActing = false;
      notifyListeners();
    }
  }

  Future<bool> pause(int trackingId) async {
    _isActing = true;
    _actionError = null;
    notifyListeners();

    try {
      await pauseWO(trackingId);
      await fetchList(page: _currentPage);
      return true;
    } catch (e) {
      _actionError = _msg(e);
      return false;
    } finally {
      _isActing = false;
      notifyListeners();
    }
  }

  Future<bool> resume(int trackingId) async {
    _isActing = true;
    _actionError = null;
    notifyListeners();

    try {
      await resumeWO(trackingId);
      await fetchList(page: _currentPage);
      return true;
    } catch (e) {
      _actionError = _msg(e);
      return false;
    } finally {
      _isActing = false;
      notifyListeners();
    }
  }

  Future<bool> complete(int trackingId) async {
    _isActing = true;
    _actionError = null;
    notifyListeners();

    try {
      await completeWO(trackingId);
      await fetchList(page: _currentPage);
      return true;
    } catch (e) {
      _actionError = _msg(e);
      return false;
    } finally {
      _isActing = false;
      notifyListeners();
    }
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}