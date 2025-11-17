import 'package:eboutic/models/produit_model.dart';
import 'package:eboutic/services/firestore_service.dart';
import 'package:eboutic/widgets/produit_card.dart';
import 'package:flutter/material.dart';

import 'product_detail_page.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  final firestoreService = FirestoreService ();
  String? _selectedCategorie; // catégorie choisie

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogue"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/ajout_produit');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Dropdown pour filtrer par catégorie
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategorie,
              hint: const Text("Filtrer par catégorie"),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "Fruits", child: Text("Fruits")),
                DropdownMenuItem(value: "Légumes", child: Text("Légumes")),
                DropdownMenuItem(value: "Céréales", child: Text("Céréales")),
                DropdownMenuItem(value: "Produits laitiers", child: Text("Produits laitiers")),
              ],
              onChanged: (val) {
                setState(() => _selectedCategorie = val);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Produit >>(
              stream: firestoreService.getProduits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun produit disponible"));
                }

                var produits = snapshot.data!;
                // 🔹 Appliquer le filtre si une catégorie est sélectionnée
                if (_selectedCategorie != null) {
                  produits = produits
                      .where((p) => p.categorie == _selectedCategorie)
                      .toList();
                }

                if (produits.isEmpty) {
                  return const Center(child: Text("Aucun produit dans cette catégorie"));
                }

                return ListView.builder(
                  itemCount: produits.length,
                  itemBuilder: (context, index) {
                    final produit = produits[index];
                    return ProduitCard (
                      produit: produit,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(produit: produit),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
