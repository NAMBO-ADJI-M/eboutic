class Utilisateur {
  final String uid;             // Identifiant unique Firebase
  final String email;           // Email de l'utilisateur
  final String nom;             // Nom affiché
  final DateTime dateInscription; // Date d'inscription

  Utilisateur({
    required this.uid,
    required this.email,
    required this.nom,
    required this.dateInscription,
  });

  // Conversion en Map pour Firestore
  Map<String, dynamic> toMap() => {
        'email': email,
        'nom': nom,
        'dateInscription': dateInscription.toIso8601String(),
      };

  // Création d'un utilisateur à partir d'un document Firestore
  factory Utilisateur.fromDoc(String uid, Map<String, dynamic> doc) {
    return Utilisateur(
      uid: uid,
      email: doc['email'] ?? '',
      nom: doc['nom'] ?? '',
      dateInscription: DateTime.tryParse(doc['dateInscription'] ?? '') ??
          DateTime.now(),
    );
  }
}
