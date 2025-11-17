import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produit_model.dart';
import '../models/commande_model.dart';
import '../models/utilisateur_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Produits
  Future<void> addProduit(Produit produit) async {
    await _db.collection('produits').doc(produit.id).set(produit.toMap());
  }

  Future<void> updateProduit(Produit produit) async {
    await _db.collection('produits').doc(produit.id).update(produit.toMap());
  }

  Future<void> deleteProduit(String id) async {
    await _db.collection('produits').doc(id).delete();
  }

  Stream<List<Produit>> getProduits() {
    return _db.collection('produits').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Produit.fromDoc(doc.id, doc.data())).toList());
  }

  // 🔹 Commandes
  Future<void> addCommande(Commande commande) async {
    await _db.collection('commandes').doc(commande.id).set(commande.toMap());
  }

  Stream<List<Commande>> getCommandes(String utilisateurId) {
    return _db
        .collection('commandes')
        .where('utilisateurId', isEqualTo: utilisateurId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Commande.fromDoc(doc.id, doc.data()))
            .toList());
  }

  Future<void> updateStatutCommande(String idCommande, String statut) async {
    await _db.collection('commandes').doc(idCommande).update({'statut': statut});
  }

  // 🔹 Utilisateurs
  Future<void> addUtilisateur(Utilisateur utilisateur) async {
    await _db.collection('utilisateurs').doc(utilisateur.uid).set(utilisateur.toMap());
  }

  Future<Utilisateur?> getUtilisateur(String uid) async {
    var doc = await _db.collection('utilisateurs').doc(uid).get();
    if (doc.exists) {
      return Utilisateur.fromDoc(doc.id, doc.data()!);
    }
    return null;
  }
}
