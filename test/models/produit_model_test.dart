import 'package:flutter_test/flutter_test.dart';
import 'package:eboutic/models/produit_model.dart';

void main() {
  test('toMap includes expected fields', () {
    final p = Produit(
      id: 'p1',
      nom: 'Banane',
      prix: 150,
      categorie: 'alimentaire',
      description: 'Bananes locales',
      imageUrl: 'https://example.com/banane.png',
      equitable: true,
    );

    final map = p.toMap();
    expect(map['nom'], 'Banane');
    expect(map['prix'], 150);
    expect(map['categorie'], 'alimentaire');
    expect(map['description'], 'Bananes locales');
    expect(map['imageUrl'], 'https://example.com/banane.png');
    expect(map['equitable'], true);
  });

  test('fromDoc reconstructs Produit and applies defaults', () {
    final doc = {
      'nom': 'Mangue',
      'prix': 200,
      'categorie': 'alimentaire',
      'description': 'Mangues bio',
      'imageUrl': 'https://example.com/mangue.png',
      'equitable': false,
    };
    final prod = Produit.fromDoc('m1', doc);

    expect(prod.id, 'm1');
    expect(prod.nom, 'Mangue');
    expect(prod.prix, 200);
    expect(prod.categorie, 'alimentaire');
    expect(prod.description, 'Mangues bio');
    expect(prod.imageUrl, 'https://example.com/mangue.png');
    expect(prod.equitable, false);
  });

  test('fromDoc handles missing fields', () {
    final prod = Produit.fromDoc('x1', <String, dynamic>{});
    expect(prod.id, 'x1');
    expect(prod.nom, '');
    expect(prod.prix, 0);
    expect(prod.categorie, '');
    expect(prod.description, '');
    expect(prod.imageUrl, '');
    expect(prod.equitable, false);
  });
}
