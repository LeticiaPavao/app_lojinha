import 'package:app_padrao/services/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _authService.authState.listen((AuthState state) {
      _user = state.session?.user;
      notifyListeners();
    });
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        userData: {'full_name': fullName},
      );
      _user = response.user;
      return null; // sem erro
    } catch (e) {
      return e.toString(); // retorna mensagem de erro
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );
      _user = response.user;
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}