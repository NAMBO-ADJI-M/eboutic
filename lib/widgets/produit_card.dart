import 'package:eboutic/models/produit_model.dart';
import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';

class ProduitCard extends StatelessWidget {
  final Produit produit;
  final VoidCallback onTap;

  const ProduitCard({super.key, required this.produit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: Hero(
          tag: produit.id,
          // ignore: undefined_method
          child: Image.network(
            produit.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(produit.nom),
        subtitle: Text("${produit.prix} FCFA"),
        trailing: produit.equitable
            ? const Icon(Icons.eco, color: Colors.green)
            : null,
        onTap: onTap,
      ),
    );
  }
}
