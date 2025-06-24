import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authService.isAuthenticated;
  User? get currentUser => _authService.currentUser;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _authService.initialize();
    } catch (e) {
      _setError('Failed to initialize authentication');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.login(email, password);
      if (!success) {
        _setError('Invalid email or password');
      }
      return success;
    } catch (e) {
      _setError('Login failed. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.register(email, password, name);
      if (!success) {
        _setError('Registration failed. Please try again.');
      }
      return success;
    } catch (e) {
      _setError('Registration failed. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.forgotPassword(email);
      if (!success) {
        _setError('Failed to send reset email');
      }
      return success;
    } catch (e) {
      _setError('Failed to send reset email. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(User updatedUser) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.updateProfile(updatedUser);
      if (!success) {
        _setError('Failed to update profile');
      }
      return success;
    } catch (e) {
      _setError('Failed to update profile. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
    } catch (e) {
      _setError('Logout failed');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}

