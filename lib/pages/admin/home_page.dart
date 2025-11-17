import 'package:eboutic/pages/admin/commande_page.dart';
import 'package:flutter/material.dart';
import 'catalogue_page.dart';

import 'profil_page.dart';

class HomePage extends StatefulWidget {
  final String utilisateurId; // UID de l'utilisateur connecté

  const HomePage({super.key, required this.utilisateurId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CataloguePage(),
      CommandesPage (utilisateurId: widget.utilisateurId),
      ProfilPage (utilisateurId: widget.utilisateurId),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Catalogue",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Commandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
