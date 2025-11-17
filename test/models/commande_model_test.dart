import 'package:flutter_test/flutter_test.dart';
import 'package:eboutic/models/commande_model.dart';
import 'package:eboutic/models/produit_commande.dart';

void main() {
  test('toMap includes expected fields and date is ISO string', () {
    final produit = ProduitCommande(nom: 'Produit A', quantite: 2, prix: 100);
    final now = DateTime.parse('2023-01-01T12:00:00Z');
    final cmd = Commande(
      id: 'c1',
      utilisateurId: 'u1',
      produits: [produit],
      total: 200,
      date: now,
    );

    final map = cmd.toMap();
    expect(map['utilisateurId'], 'u1');
    expect(map['total'], 200);
    expect(map['produits'], isA<List>());
    expect(map['date'], now.toIso8601String());
    expect(map['statut'], 'en_attente');
  });

  test('fromDoc rebuilds Commande from map and respects produit mapping', () {
    final produit = ProduitCommande(nom: 'Produit B', quantite: 3, prix: 50);
    final cmd = Commande(
      id: 'c2',
      utilisateurId: 'u2',
      produits: [produit],
      total: 150,
      date: DateTime.parse('2024-02-02T10:00:00Z'),
      statut: 'validée',
    );

    final map = cmd.toMap();
    final rebuilt = Commande.fromDoc('c2', map);

    expect(rebuilt.id, 'c2');
    expect(rebuilt.utilisateurId, 'u2');
    expect(rebuilt.total, 150);
    expect(rebuilt.statut, 'validée');
    expect(rebuilt.produits, isNotEmpty);
    expect(rebuilt.produits.first.nom, produit.nom);
  });

  test('fromDoc handles missing fields gracefully', () {
    final minimalMap = <String, dynamic>{};
    final cmd = Commande.fromDoc('c3', minimalMap);

    expect(cmd.id, 'c3');
    expect(cmd.utilisateurId, isA<String>());
    expect(cmd.produits, isA<List>());
    expect(cmd.statut, 'en_attente');
    expect(cmd.date, isA<DateTime>());
  });
}
