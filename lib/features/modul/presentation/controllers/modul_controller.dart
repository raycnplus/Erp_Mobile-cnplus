import 'package:flutter/material.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/models/modul_model.dart';
import '../../../../core/network/dio_client.dart';

enum ModulStatus { initial, loading, loaded, error }

class ModulController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final DioClient _dioClient;

  ModulController({
    required AuthRepository authRepository,
    required DioClient dioClient,
  })  : _authRepository = authRepository,
        _dioClient = dioClient;

  ModulStatus _status = ModulStatus.initial;
  String? _errorMessage;
  UserEntity? _currentUser;
  List<ModulModel> _modules = [];

  ModulStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserEntity? get currentUser => _currentUser;
  List<ModulModel> get modules => _modules;
  bool get isLoading => _status == ModulStatus.loading;
  String get userName => _currentUser?.displayName ?? 'User';
  String get userImage => _currentUser?.fullImageUrl ?? '';

  Future<void> initialize() async {
    _status = ModulStatus.loading;
    notifyListeners();

    try {
      final refreshResult = await _authRepository.refreshToken();
      if (refreshResult['success'] == false) {
        _status = ModulStatus.error;
        _errorMessage = 'Session expired. Please login again.';
        notifyListeners();
        return;
      }

      final userData = await _authRepository.getUserData();
      if (userData.isNotEmpty) {
        _currentUser = UserEntity(
          idUser:      int.tryParse(userData['id_user'] ?? '0') ?? 0,
          username:    userData['username'] ?? '',
          namaLengkap: userData['nama_lengkap'] ?? '',
          email:       userData['email'],
        );
      }

      await _fetchModules();

      _status = ModulStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = ModulStatus.error;
      _errorMessage = 'Failed to load: $e';
      notifyListeners();
    }
  }

  Future<void> _fetchModules() async {
    final response = await _dioClient.dio.get('/auth/modules');
    final List list = response.data['modules'];
    _modules = list.map((e) => ModulModel.fromJson(e)).toList();
  }

  Future<void> refresh() async => await initialize();

  Future<bool> logout() async {
    _status = ModulStatus.loading;
    notifyListeners();

    try {
      final result = await _authRepository.logout();
      if (result['success'] == true) {
        _currentUser = null;
        _modules = [];
        _status = ModulStatus.initial;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      _status = ModulStatus.error;
      notifyListeners();
      return false;
    }
  }
}