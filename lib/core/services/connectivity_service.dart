import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final _internetChecker = InternetConnectionChecker();
  final _logger = Logger();
  bool _isDisposed = false;

  Stream<bool> get connectionStream => _controller.stream;

  ConnectivityService() {
    _initializeService();
  }

  void _initializeService() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateConnectionStatus);
    
    // Check initial connection
    checkInitialConnection();
  }

  Future<void> checkInitialConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      await _updateConnectionStatus(results);
    } catch (e) {
      _logger.e('Initial connection check error:', error: e);
      _safeAddToController(false);
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (_isDisposed) return;

    try {
      bool isConnected = false;
      if (!results.contains(ConnectivityResult.none)) {
        isConnected = await _internetChecker.hasConnection;
      }
      _safeAddToController(isConnected);
    } catch (e) {
      _logger.e('Connection status update error:', error: e);
      _safeAddToController(false);
    }
  }

  void _safeAddToController(bool value) {
    if (!_isDisposed && !_controller.isClosed) {
      _controller.add(value);
    }
  }

  Future<bool> hasInternetConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (!results.contains(ConnectivityResult.none)) {
        return await _internetChecker.hasConnection;
      }
    } catch (e) {
      _logger.e('Internet connection check error:', error: e);
    }
    return false;
  }

  void dispose() {
    _isDisposed = true;
    _connectivitySubscription.cancel();
    _controller.close();
  }
}