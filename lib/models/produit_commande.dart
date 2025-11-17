class ProduitCommande {
  final String nom;
  final int quantite;
  final int prix;

  ProduitCommande({
    required this.nom,
    required this.quantite,
    required this.prix,
  });

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'quantite': quantite,
        'prix': prix,
      };

  factory ProduitCommande.fromMap(Map<String, dynamic> map) {
    return ProduitCommande(
      nom: map['nom'] ?? '',
      quantite: map['quantite'] ?? 0,
      prix: map['prix'] ?? 0,
    );
  }
}
