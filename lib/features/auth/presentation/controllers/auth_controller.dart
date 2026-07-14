import 'package:flutter/material.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;

  AuthController({
    required LoginUseCase loginUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _authRepository = authRepository;

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _status == AuthStatus.loading;

  Future<bool> login({
    required String username,
    required String password,
    required String database,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _loginUseCase.execute(
        username: username,
        password: password,
        database: database,
      );

      if (result['success'] == true) {
        _status = AuthStatus.authenticated;
        _userData = result['user'] != null ? result['user'].toMap() : null;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = result['message'] ?? 'Login gagal';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final result = await _authRepository.logout();
      
      _status = AuthStatus.unauthenticated;
      _userData = null;
      _errorMessage = null;
      notifyListeners();
      
      return result['success'] == true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Logout gagal: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    
    if (isLoggedIn) {
      _status = AuthStatus.authenticated;
      final userData = await _authRepository.getUserData();
      _userData = userData;
    } else {
      _status = AuthStatus.unauthenticated;
      _userData = null;
    }
    
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}