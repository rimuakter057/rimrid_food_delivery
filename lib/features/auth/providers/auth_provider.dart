import 'package:flutter/foundation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/datasources/remote/auth_remote_data_source.dart';
import '../../../data/mock/mock_user.dart';
import '../../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRemoteDataSource _authRemoteDataSource;

  UserModel? _currentUser = MockUser.currentUser;
  bool _isAuthenticated = true; // Logged in by default for smooth UX
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthRemoteDataSource? authRemoteDataSource})
      : _authRemoteDataSource = authRemoteDataSource ?? AuthRemoteDataSource();

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // DummyJSON (free, keyless fake-auth API) only accepts its own seed
      // accounts, so we authenticate against its demo username regardless of
      // what the user typed, but keep whatever email they entered on the profile.
      final response = await _authRemoteDataSource.login(
        AuthApiConstants.demoUsername,
        AuthApiConstants.demoPassword,
      );

      _currentUser = _mapDummyJsonUser(response, fallbackEmail: email.isNotEmpty ? email : null);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // DummyJSON's /users/add "creates" a user without persisting it server-side,
      // but it's a real HTTP round trip and returns a real generated profile.
      final response = await _authRemoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      _currentUser = _mapDummyJsonUser(response, fallbackEmail: email, fallbackPhone: phone);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  UserModel _mapDummyJsonUser(Map<String, dynamic> data, {String? fallbackEmail, String? fallbackPhone}) {
    final firstName = (data['firstName'] ?? '').toString();
    final lastName = (data['lastName'] ?? '').toString();
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    return UserModel(
      id: (data['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
      name: fullName.isNotEmpty ? fullName : MockUser.currentUser.name,
      email: (data['email'] ?? fallbackEmail ?? MockUser.currentUser.email).toString(),
      phone: (data['phone'] ?? fallbackPhone ?? MockUser.currentUser.phone).toString(),
      avatarUrl: (data['image'] ?? MockUser.currentUser.avatarUrl).toString(),
    );
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
