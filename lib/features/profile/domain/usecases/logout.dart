import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/repositories/profile_repository.dart';

class Logout {
  final ProfileRepository repository;
  final FlutterSecureStorage storage;

  Logout(this.repository, this.storage);

  Future<void> call() async {
    try {
      await repository.logout();
    } finally {
      await storage.deleteAll();
    }
  }
}