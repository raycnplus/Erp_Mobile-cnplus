import '../../domain/entities/profile_entity.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepository({required this.remoteDataSource});

  Future<ProfileEntity> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}