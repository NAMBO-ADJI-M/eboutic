import 'package:eboutic/models/commande_model.dart';
import 'package:eboutic/models/produit_commande.dart';
import 'package:eboutic/models/produit_model.dart';
import 'package:eboutic/services/firestore_service.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Produit produit;
  const ProductDetailPage({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text(produit.nom)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: produit.id,
              // ignore: undefined_method
              child: Image.network(
                produit.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              produit.nom,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "${produit.prix} FCFA",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(produit.description),
            const SizedBox(height: 16),
            produit.equitable
                ? Row(
                    children: const [
                      Icon(Icons.eco, color: Colors.green),
                      SizedBox(width: 8),
                      Text("Produit équitable"),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Commander"),
                onPressed: () async {
                  final commande = Commande(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    utilisateurId: "demoUser", // ⚠️ à remplacer par l’UID réel
                    produits: [
                      ProduitCommande(
                        nom: produit.nom,
                        quantite: 1,
                        prix: produit.prix,
                      ),
                    ],
                    total: produit.prix,
                    date: DateTime.now(),
                  );

                  await firestoreService.addCommande(commande);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Commande passée avec succès"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
