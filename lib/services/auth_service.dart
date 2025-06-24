import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'https://api.careerflow.com'; // Placeholder URL
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  User? _currentUser;

  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null && _currentUser != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    final userData = prefs.getString(_userKey);
    
    if (userData != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userData));
      } catch (e) {
        // Clear invalid user data
        await logout();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // For demo purposes, we'll simulate a successful login
      // In a real app, this would make an HTTP request to your backend
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock successful response
      if (email.isNotEmpty && password.isNotEmpty) {
        _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        _currentUser = User(
          id: 'user_123',
          email: email,
          name: 'John Doe',
          phone: '+1234567890',
          location: 'San Francisco, CA',
          professionalSummary: 'Experienced software developer with 5+ years in mobile app development.',
          skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
          privacySettings: {
            'showEmail': true,
            'showPhone': false,
            'showLocation': true,
          },
        );
        
        await _saveAuthData();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      // For demo purposes, we'll simulate a successful registration
      // In a real app, this would make an HTTP request to your backend
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock successful response
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        _currentUser = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          name: name,
          privacySettings: {
            'showEmail': true,
            'showPhone': false,
            'showLocation': true,
          },
        );
        
        await _saveAuthData();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock successful response
      return email.isNotEmpty;
    } catch (e) {
      print('Forgot password error: $e');
      return false;
    }
  }

  Future<bool> updateProfile(User updatedUser) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentUser = updatedUser;
      await _saveAuthData();
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_token != null) {
      await prefs.setString(_tokenKey, _token!);
    }
    
    if (_currentUser != null) {
      await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
    }
  }

  // Helper method to get authorization headers
  Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };
}

