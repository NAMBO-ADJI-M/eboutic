class Produit {
  final String id;            // Identifiant unique du produit
  final String nom;           // Nom du produit
  final int prix;             // Prix en FCFA
  final String categorie;     // Catégorie (alimentaire, artisanat, etc.)
  final String description;   // Description du produit
  final String imageUrl;      // URL de l'image (hébergée sur Supabase)
  final bool equitable;       // Indique si le produit est équitable

  Produit({
    required this.id,
    required this.nom,
    required this.prix,
    required this.categorie,
    required this.description,
    required this.imageUrl,
    this.equitable = false,
  });

  // Conversion en Map pour Firestore
  Map<String, dynamic> toMap() => {
        'nom': nom,
        'prix': prix,
        'categorie': categorie,
        'description': description,
        'imageUrl': imageUrl,
        'equitable': equitable,
      };

  // Création d'un objet Produit à partir d'un document Firestore
  factory Produit.fromDoc(String id, Map<String, dynamic> doc) {
    return Produit(
      id: id,
      nom: doc['nom'] ?? '',
      prix: doc['prix'] ?? 0,
      categorie: doc['categorie'] ?? '',
      description: doc['description'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      equitable: doc['equitable'] ?? false,
    );
  }
}
