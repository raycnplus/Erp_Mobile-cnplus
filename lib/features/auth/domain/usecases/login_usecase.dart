// lib/features/auth/domain/usecases/login_usecase.dart

import '../../data/repositories/auth_repository.dart';
import '../../data/models/login_request.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Map<String, dynamic>> execute({
    required String username,
    required String password,
    required String database,
  }) async {
    // Validation
    if (username.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Username tidak boleh kosong',
      };
    }

    if (password.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Password tidak boleh kosong',
      };
    }

    if (database.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Database harus dipilih',
      };
    }

    final request = LoginRequest(
      username: username.trim(),
      password: password.trim(),
      database: database.trim(),
    );

    return await _repository.login(request);
  }
}