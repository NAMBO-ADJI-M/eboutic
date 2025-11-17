import 'produit_commande.dart';

class Commande {
  final String id;                  // Identifiant unique de la commande
  final String utilisateurId;       // UID de l'utilisateur qui passe la commande
  final List<ProduitCommande> produits; // Liste des produits commandés
  final int total;                  // Montant total de la commande
  final DateTime date;              // Date de la commande
  final String statut;              // Statut (en_attente, validée, livrée)

  Commande({
    required this.id,
    required this.utilisateurId,
    required this.produits,
    required this.total,
    required this.date,
    this.statut = "en_attente",
  });

  // Conversion en Map pour Firestore
  Map<String, dynamic> toMap() => {
        'utilisateurId': utilisateurId,
        'produits': produits.map((p) => p.toMap()).toList(),
        'total': total,
        'date': date.toIso8601String(),
        'statut': statut,
      };

  // Création d'une commande à partir d'un document Firestore
  factory Commande.fromDoc(String id, Map<String, dynamic> doc) {
    var produitsData = doc['produits'] as List<dynamic>? ?? [];
    return Commande(
      id: id,
      utilisateurId: doc['utilisateurId'] ?? '',
      produits: produitsData
          .map((p) => ProduitCommande.fromMap(p as Map<String, dynamic>))
          .toList(),
      total: doc['total'] ?? 0,
      date: DateTime.tryParse(doc['date'] ?? '') ?? DateTime.now(),
      statut: doc['statut'] ?? 'en_attente',
    );
  }
}
