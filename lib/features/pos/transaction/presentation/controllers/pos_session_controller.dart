import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/models/pos_transaction_models.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/domain/usecases/pos_transaction_usecases.dart';

class PosSessionController extends ChangeNotifier {
  final GetPosCurrentSession getCurrent;
  final OpenPosSession openSessionUC;
  final GetPosCloseSummary getCloseSummaryUC;
  final ClosePosSession closeSessionUC;
  final CreatePosCashMovement createMovementUC;
  final DeletePosCashMovement deleteMovementUC;

  PosSessionController({
    required this.getCurrent,
    required this.openSessionUC,
    required this.getCloseSummaryUC,
    required this.closeSessionUC,
    required this.createMovementUC,
    required this.deleteMovementUC,
  });

  int? _idStore;
  String _storeName = '';

  PosCashierSession? _session;
  bool _hasLoaded = false;
  bool _isLoading = false;
  String? _error;

  bool _isSubmitting = false;
  String? _formError;
  String? _successMessage;

  PosCashierSession? _closeSummary;
  bool _isLoadingSummary = false;
  String? _summaryError;
  PosCashierSession? _lastClosed;

  final List<PosCashMovement> _movements = [];

  int? get idStore => _idStore;
  String get storeName => _storeName;

  PosCashierSession? get session => _session;
  bool get hasActiveSession => _session?.isOpen ?? false;
  bool get hasLoaded => _hasLoaded;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isSubmitting => _isSubmitting;
  String? get formError => _formError;

  PosCashierSession? get closeSummary => _closeSummary;
  bool get isLoadingSummary => _isLoadingSummary;
  String? get summaryError => _summaryError;
  PosCashierSession? get lastClosedSession => _lastClosed;

  List<PosCashMovement> get movements => List.unmodifiable(_movements);

  String? consumeSuccessMessage() {
    final m = _successMessage;
    _successMessage = null;
    return m;
  }

  double differenceFor(double closingBalance) =>
      closingBalance - (_closeSummary?.expectedBalance ?? _session?.expectedBalance ?? 0);

  void setStore(int idStore, String storeName) {
    if (_idStore != idStore) {
      _session = null;
      _hasLoaded = false;
      _error = null;
      _closeSummary = null;
      _lastClosed = null;
      _movements.clear();
    }
    _idStore = idStore;
    _storeName = storeName;
    _isLoading = true;
  }

  Future<void> loadCurrent({bool silent = false}) async {
    final id = _idStore;
    if (id == null) return;

    if (!silent) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final prevEnc = _session?.encryption;
      final r = await getCurrent(id);
      _session = r.hasActiveSession ? r.session : null;
      if (_session?.encryption != prevEnc) _movements.clear();
      _hasLoaded = true;
    } catch (e) {
      if (!silent) _error = _msg(e);
    } finally {
      if (!silent) _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSession() => loadCurrent(silent: true);

  Future<bool> openSession(double openingBalance) async {
    final id = _idStore;
    if (id == null) return false;

    _isSubmitting = true;
    _formError = null;
    notifyListeners();

    try {
      _session = await openSessionUC(id, openingBalance);
      _hasLoaded = true;
      _lastClosed = null;
      _movements.clear();
      _successMessage = 'Session opened';
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> loadCloseSummary() async {
    final enc = _session?.encryption;
    if (enc == null) return;

    _isLoadingSummary = true;
    _summaryError = null;
    notifyListeners();

    try {
      _closeSummary = await getCloseSummaryUC(enc);
    } catch (e) {
      _summaryError = _msg(e);
      _closeSummary = null;
    } finally {
      _isLoadingSummary = false;
      notifyListeners();
    }
  }

  Future<bool> closeSession({required double closingBalance, String? notes}) async {
    final enc = _session?.encryption;
    if (enc == null) return false;

    _isSubmitting = true;
    _formError = null;
    notifyListeners();

    try {
      _lastClosed = await closeSessionUC(enc, closingBalance: closingBalance, notes: notes);
      _session = null;
      _closeSummary = null;
      _movements.clear();
      _successMessage = 'Session closed';
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> addCashMovement({
    required String type, 
    required double amount,
    String? notes,
  }) async {
    final id = _idStore;
    if (id == null || !hasActiveSession) return false;

    _isSubmitting = true;
    _formError = null;
    notifyListeners();

    try {
      final m = await createMovementUC(id, type: type, amount: amount, notes: notes);
      _movements.insert(0, m);
      _successMessage = 'Cash movement saved';
      await loadCurrent(silent: true);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCashMovement(PosCashMovement m) async {
    if (m.encryption.isEmpty) {
      _formError = 'Cash movement id is missing';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _formError = null;
    notifyListeners();

    try {
      await deleteMovementUC(m.encryption);
      _movements.removeWhere((e) => e.encryption == m.encryption);
      _successMessage = 'Cash movement deleted';
      await loadCurrent(silent: true);
      return true;
    } catch (e) {
      _formError = _msg(e);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String _msg(dynamic e) => e.toString().replaceFirst('Exception:', '').trim();
}