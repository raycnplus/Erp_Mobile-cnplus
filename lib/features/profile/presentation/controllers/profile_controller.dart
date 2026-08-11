import 'package:flutter/material.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/logout.dart';

class ProfileController extends ChangeNotifier {
  final GetProfile getProfile;
  final Logout logout;

  ProfileController({
    required this.getProfile,
    required this.logout,
  });

  ProfileEntity? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await getProfile();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _profile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> performLogout() async {
    try {
      await logout();
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}