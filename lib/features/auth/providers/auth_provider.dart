import 'package:flutter/foundation.dart';
import '../../../data/mock/mock_user.dart';
import '../../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser = MockUser.currentUser;
  bool _isAuthenticated = true; // Logged in by default for smooth UX
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate async state

    _currentUser = MockUser.currentUser.copyWith(email: email);
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      avatarUrl: MockUser.currentUser.avatarUrl,
    );
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = _currentUser!.copyWith(
      name: name,
      email: email,
      phone: phone,
    );
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
