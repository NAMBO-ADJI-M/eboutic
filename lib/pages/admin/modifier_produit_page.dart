import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eboutic/models/produit_model.dart';
import 'package:eboutic/services/firestore_service.dart';
import 'package:eboutic/services/storage_service.dart';

class ModifierProduitPage extends StatefulWidget {
  final Produit produit;
  const ModifierProduitPage({super.key, required this.produit});

  @override
  State<ModifierProduitPage> createState() => _ModifierProduitPageState();
}

class _ModifierProduitPageState extends State<ModifierProduitPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _storageService = StorageService();

  late String _nom;
  late String _categorie;
  late String _description;
  late int _prix;
  late bool _equitable;
  late String? _imageUrl;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nom = widget.produit.nom;
    _categorie = widget.produit.categorie;
    _description = widget.produit.description;
    _prix = widget.produit.prix;
    _equitable = widget.produit.equitable;
    _imageUrl = widget.produit.imageUrl;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmer la modification"),
        content: const Text("Voulez-vous enregistrer les modifications ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loading = true);

    final produit = Produit(
      id: widget.produit.id,
      nom: _nom,
      prix: _prix,
      categorie: _categorie,
      description: _description,
      imageUrl: _imageUrl ?? '',
      equitable: _equitable,
    );

    await _firestoreService.updateProduit(produit);

    if (!context.mounted) return;

    setState(() => _loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produit modifié avec succès")),
    );

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final file = File(pickedFile.path);
        final url = await _storageService.uploadImage(file);
        setState(() => _imageUrl = url);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erreur lors de l'upload: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Promotion via variable locale
    final imageUrl = _imageUrl;

    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le produit")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _nom,
                decoration: const InputDecoration(labelText: "Nom"),
                onSaved: (val) => _nom = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? "Entrez un nom" : null,
              ),
              TextFormField(
                initialValue: _categorie,
                decoration: const InputDecoration(labelText: "Catégorie"),
                onSaved: (val) => _categorie = val ?? '',
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val ?? '',
              ),
              TextFormField(
                initialValue: _prix.toString(),
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
                label: const Text("Changer l'image"),
                onPressed: _pickImage,
              ),
              if (imageUrl != null && imageUrl.isNotEmpty) ...[
                const SizedBox(height: 12),
                Image(
                  image: NetworkImage(imageUrl),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ] else ...[
                const SizedBox(height: 12),
                const Text("Aucune image sélectionnée"),
              ],
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      child: const Text("Enregistrer les modifications"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
