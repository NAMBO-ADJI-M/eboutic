import 'package:eboutic/models/utilisateur_model.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  Utilisateur? _utilisateur;
  bool _loading = false;

  Utilisateur? get utilisateur => _utilisateur;
  bool get isAuthenticated => _utilisateur != null;
  bool get loading => _loading;

  // 🔹 Connexion
  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    _utilisateur = await _authService.login(email, password);

    _loading = false;
    notifyListeners();
  }

  // 🔹 Inscription
  Future<void> register(String email, String password, String nom) async {
    _loading = true;
    notifyListeners();

    _utilisateur = await _authService.register(email, password, nom);

    _loading = false;
    notifyListeners();
  }

  // 🔹 Déconnexion
  Future<void> logout() async {
    await _authService.logout();
    _utilisateur = null;
    notifyListeners();
  }

  // 🔹 Charger utilisateur courant
  void loadCurrentUser() {
    _utilisateur = _authService.getCurrentUser();
    notifyListeners();
  }
}
