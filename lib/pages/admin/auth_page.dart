import 'package:eboutic/models/utilisateur_model.dart';
import 'package:flutter/material.dart';
import 'package:eboutic/services/auth_service.dart';

import 'catalogue_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService ();

  String _email = '';
  String _password = '';
  String _nom = '';
  bool _isLogin = true;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);

    Utilisateur ? user;
    if (_isLogin) {
      user = await _authService.login(_email, _password);
    } else {
      user = await _authService.register(_email, _password, _nom);
    }

    setState(() => _loading = false);

    if (user != null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CataloguePage()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur d'authentification")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? "Connexion" : "Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_isLogin)
                TextFormField(
                  decoration: const InputDecoration(labelText: "Nom"),
                  onSaved: (val) => _nom = val ?? '',
                  validator: (val) =>
                      val == null || val.isEmpty ? "Entrez votre nom" : null,
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onSaved: (val) => _email = val ?? '',
                validator: (val) =>
                    val == null || !val.contains('@') ? "Email invalide" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
                onSaved: (val) => _password = val ?? '',
                validator: (val) =>
                    val == null || val.length < 6 ? "Min 6 caractères" : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? "Se connecter" : "S'inscrire"),
                    ),
              TextButton(
                onPressed: () {
                  setState(() => _isLogin = !_isLogin);
                },
                child: Text(_isLogin
                    ? "Créer un compte"
                    : "Déjà inscrit ? Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
