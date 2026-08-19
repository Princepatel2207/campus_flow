import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  bool get isAdmin => _currentUser?.role == 'admin';

  bool get isUser => _currentUser?.role == 'user';

  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Temporary local authentication.
    //
    // Later this will be replaced by:
    // Flutter -> Node.js API -> MongoDB

    if (email == 'admin@campus.com' &&
        password == 'admin123') {
      _currentUser = UserModel(
        id: '1',
        name: 'Campus Admin',
        email: email,
        role: 'admin',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    }

    if (email == 'user@campus.com' &&
        password == 'user123') {
      _currentUser = UserModel(
        id: '2',
        name: 'Student User',
        email: email,
        role: 'user',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();

    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}