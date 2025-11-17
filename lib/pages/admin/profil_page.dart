import 'package:eboutic/models/utilisateur_model.dart';
import 'package:eboutic/services/auth_service.dart';
import 'package:eboutic/services/firestore_service.dart';
import 'package:flutter/material.dart';

import 'auth_page.dart';

class ProfilPage extends StatefulWidget {
  final String utilisateurId;

  const ProfilPage({super.key, required this.utilisateurId});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  Utilisateur? _utilisateur;

  @override
  void initState() {
    super.initState();
    _loadUtilisateur();
  }

  Future<void> _loadUtilisateur() async {
    final user = await _firestoreService.getUtilisateur(widget.utilisateurId);
    if (!mounted) return;
    setState(() => _utilisateur = user);
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) return; // ✅ sécurité

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  Future<void> _deleteAccount() async {
    // 🔹 Dialogue de confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text(
            "Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm != true) return; // ✅ Annuler si refus

    if (_utilisateur != null) {
      // ⚠️ Exemple simplifié : ici tu pourrais mettre la vraie logique de suppression
      await _firestoreService.addUtilisateur(
        Utilisateur(
          uid: _utilisateur!.uid,
          email: '',
          nom: '',
          dateInscription: DateTime.now(),
        ),
      );
    }

    await _logout(); // ✅ déconnexion après suppression
  }

  @override
  Widget build(BuildContext context) {
    if (_utilisateur == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mon profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                _utilisateur!.nom.isNotEmpty
                    ? _utilisateur!.nom[0].toUpperCase()
                    : "?",
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _utilisateur!.nom,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(_utilisateur!.email),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Se déconnecter"),
              onPressed: _logout,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("Supprimer mon compte"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _deleteAccount,
            ),
          ],
        ),
      ),
    );
  }
}
