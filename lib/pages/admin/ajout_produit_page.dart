import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:eboutic/models/produit_model.dart';
import 'package:eboutic/services/firestore_service.dart';
import 'package:eboutic/services/storage_service.dart';

class AjoutProduitPage extends StatefulWidget {
  const AjoutProduitPage({super.key});

  @override
  State<AjoutProduitPage> createState() => _AjoutProduitPageState();
}

class _AjoutProduitPageState extends State<AjoutProduitPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _storageService = StorageService();

  String _nom = '';
  String _categorie = '';
  String _description = '';
  int _prix = 0;
  bool _equitable = false;
  String? _imageUrl;

  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);

    final produit = Produit(
      id: const Uuid().v4(),
      nom: _nom,
      prix: _prix,
      categorie: _categorie,
      description: _description,
      imageUrl: _imageUrl ?? '',
      equitable: _equitable,
    );

    await _firestoreService.addProduit(produit);

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produit ajouté avec succès")),
    );

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path); // ✅ conversion en File
      final url = await _storageService.uploadImage(file);
      setState(() => _imageUrl = url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un produit")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Nom"),
                onSaved: (val) => _nom = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? "Entrez un nom" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Catégorie"),
                onSaved: (val) => _categorie = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Prix (FCFA)"),
                keyboardType: TextInputType.number,
                onSaved: (val) => _prix = int.tryParse(val ?? '0') ?? 0,
              ),
              SwitchListTile(
                title: const Text("Produit équitable"),
                value: _equitable,
                onChanged: (val) => setState(() => _equitable = val),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Choisir une image"),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Ajouter le produit"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
