import '../entities/profile_entity.dart';
import '../../data/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<ProfileEntity> call() async {
    return await repository.getProfile();
  }
}