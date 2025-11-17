import 'package:eboutic/models/utilisateur_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Inscription avec email et mot de passe
  Future<Utilisateur?> register(String email, String password, String nom) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;
      if (user != null) {
        return Utilisateur(
          uid: user.uid,
          email: user.email ?? '',
          nom: nom,
          dateInscription: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint ("Erreur inscription: $e");
    }
    return null;
  }

  // 🔹 Connexion avec email et mot de passe
  Future<Utilisateur?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;
      if (user != null) {
        return Utilisateur(
          uid: user.uid,
          email: user.email ?? '',
          nom: user.displayName ?? '',
          dateInscription: user.metadata.creationTime ?? DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint("Erreur connexion: $e");
    }
    return null;
  }

  // 🔹 Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 🔹 Utilisateur courant
  Utilisateur? getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return Utilisateur (
        uid: user.uid,
        email: user.email ?? '',
        nom: user.displayName ?? '',
        dateInscription: user.metadata.creationTime ?? DateTime.now(),
      );
    }
    return null;
  }
}
